import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_atoms/blocs/boot/boot_bloc_cubit.dart';
import 'package:flutter_atoms/models/app_navigation_state.dart';
import 'package:flutter_atoms/models/navigation_model.dart';
import 'package:flutter_atoms/models/version_model.dart';
import 'package:flutter_atoms/widgets/jet_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persist_theme/persist_theme.dart';

import 'boot_page.dart';

class JetApp extends StatefulWidget {
  static final appKey = GlobalKey<NavigatorState>();
  final List<RepositoryProvider> topLevelProviders;
  final List<BlocProvider> topLevelBlocs;

  final GenerateAppTitle onGenerateTitle;

  final NavigationModel navigationModel;

  final Map<String, WidgetBuilder> _routes = <String, WidgetBuilder>{};


  WidgetBuilder bootWidget;

  final Widget logo;

  final String repeatLoadLabel;

  final Future<bool> Function() onAppStart;

  final String nextRoute;

  JetApp({
    Key key,
    @required this.navigationModel,
    @required this.onGenerateTitle,
    this.onAppStart,
    this.nextRoute,
    this.logo,
    this.repeatLoadLabel,
    this.bootWidget,
    this.topLevelProviders,
    this.topLevelBlocs,
  }) : super(key: key) {
    if (navigationModel.pagesMap["/"] == null) {
      if (bootWidget == null) {
        assert(nextRoute != null, "Next route should be defined");
        bootWidget = (context) =>
            BootPage(logo: logo,
                repeatLabelText: repeatLoadLabel,
                nextRoute: nextRoute);
      }
      navigationModel.addPath("/", bootWidget);
    }
  }

  @override
  _JetAppState createState() => _JetAppState();
}

class _JetAppState extends State<JetApp> {
  ThemeModel _themeModel;

  JetAppRouterDelegate _appRouterDelegate;


  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider<VersionModel>(
              create: (context) =>
              VersionModel()
                ..load()),
        ]
          ..addAll(widget.topLevelProviders ?? []),
        child: MultiBlocProvider(
            providers: [
              BlocProvider<BootBlocCubit>(
                  create: (context) => BootBlocCubit(widget.onAppStart))
            ]
              ..addAll(widget.topLevelBlocs ?? []),
            child: PersistTheme(
              model: _themeModel,
              builder: (context, themeModel, child) {
                return MaterialApp.router(
                  debugShowCheckedModeBanner: false,
                  theme: themeModel.theme,
                  onGenerateTitle: widget.onGenerateTitle,
                  routerDelegate: _appRouterDelegate,
                  routeInformationParser: widget.navigationModel,
                );
              },
            )));
  }

  @override
  void initState() {
    var _textTheme =
    ThemeData
        .dark()
        .textTheme
        .apply(fontFamily: 'Core Sans DS');

    _themeModel = ThemeModel(
      customLightTheme: ThemeData(fontFamily: 'Core Sans DS'),
      customDarkTheme: ThemeData.dark().copyWith(textTheme: _textTheme),
    );

    _appRouterDelegate =
        JetAppRouterDelegate(AppNavigationState(widget.navigationModel));
  }
}

class JetAppRouterDelegate extends RouterDelegate<String>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<String> {
  final jetAppNavigatorKey = GlobalKey<NavigatorState>();
  final AppNavigationState state;
  final Map<String, Widget> pageWidgets = {};
  RootNavigatorObserver _observer;

  JetAppRouterDelegate(this.state) {
    _observer = RootNavigatorObserver(state.navigationModel);
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      observers: [_observer],

      onGenerateRoute: (settings) {
        Router.of(context).backButtonDispatcher.takePriority();
        var screen = state.navigationModel.getScreenByPath(settings.name);
        var isJetPage = screen.path == screen.group.page.path;
        var _builder = isJetPage
            ? screen.builder
            : (context) => JetPage(screen.path, state);
        // if (!isJetPage) {
        //   screen.group.page.backButtonDispatcher = Router
        //       .of(context)
        //       .backButtonDispatcher;
        //   screen.group.page.backButtonDispatcher.takePriority();
        // }
        return MaterialPageRoute(settings: settings, builder: _builder);
      },
      initialRoute: "/",
    );
  }

  @override
  // TODO: implement navigatorKey
  GlobalKey<NavigatorState> get navigatorKey => jetAppNavigatorKey;

  @override
  Future<void> setNewRoutePath(String configuration) {
    notifyListeners();
  }
}

class RootNavigatorObserver extends NavigatorObserver {
  final NavigationModel navigationModel;

  RootNavigatorObserver(this.navigationModel);

  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
  }

  @override
  void didReplace({Route<dynamic> newRoute, Route<dynamic> oldRoute}) {
    print("root observer replace");
  }


  @override
  void didRemove(Route<dynamic> route, Route<dynamic> previousRoute) {
    print("root observer remove");
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    print("root observer pop: route - ${route.settings.name}, prev - ${previousRoute.settings.name}");
    var jetPage = navigationModel.getPageByPath(previousRoute.settings.name);
    // Нужно поискать другие варианты проставить backButtonDispatcher в случае, если пользователь возвращается через стрелку AppBar
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      print("Restore back button dispatcher");
      jetPage.backButtonDispatcher.takePriority();
    });
  }
}