
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

// ignore: must_be_immutable
class JetApp extends StatefulWidget {
  static final appKey = GlobalKey<NavigatorState>();
  final List<RepositoryProvider> topLevelProviders;
  final List<BlocProvider> topLevelBlocs;

  final GenerateAppTitle onGenerateTitle;

  final NavigationModel navigationModel;

  WidgetBuilder bootWidget;

  final Widget logo;

  final String repeatLoadLabel;

  final Future<bool> Function() onAppStart;

  final String nextRoute;

  final ThemeModel Function(BuildContext context) themeModelBuilder;

  final Iterable<Locale> supportedLocales;

  final Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates;

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
    this.themeModelBuilder,
    this.supportedLocales,
    this.localizationsDelegates,
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

  JetAppRouterDelegate _appRouterDelegate;

  ThemeModel _themeModel;


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
                  localizationsDelegates: widget.localizationsDelegates,
                  supportedLocales: widget.supportedLocales,
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
    super.initState();
    _themeModel = widget.themeModelBuilder != null ? widget.themeModelBuilder(context) : defaultThemeModel();
    _appRouterDelegate =
        JetAppRouterDelegate(AppNavigationState(widget.navigationModel));
  }

  ThemeModel defaultThemeModel(){
    var _textTheme =
    ThemeData
        .dark()
        .textTheme
        .apply(fontFamily: 'Core Sans DS');

    return ThemeModel(
      customLightTheme: ThemeData(fontFamily: 'Core Sans DS'),
      customDarkTheme: ThemeData.dark().copyWith(textTheme: _textTheme),
    );

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
        return MaterialPageRoute(settings: settings, builder: _builder);
      },
      initialRoute: "/",
    );
  }

  @override
  // TODO: implement navigatorKey
  GlobalKey<NavigatorState> get navigatorKey => jetAppNavigatorKey;

  @override
  Future<void> setNewRoutePath(String configuration) async {
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
  }


  @override
  void didRemove(Route<dynamic> route, Route<dynamic> previousRoute) {
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    var jetPage = navigationModel.getPageByPath(previousRoute.settings.name);
    // Нужно поискать другие варианты проставить backButtonDispatcher в случае, если пользователь возвращается через стрелку AppBar
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      try {
        jetPage.backButtonDispatcher.takePriority();
      } catch (ignore) {
      }
    });
  }
}