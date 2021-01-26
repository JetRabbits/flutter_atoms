import 'package:flutter/material.dart';
import 'package:flutter_atoms/blocs/blocs.dart';
import 'package:flutter_atoms/blocs/navigator/nav_bar_cubit.dart';
import 'package:flutter_atoms/models/app_navigation_state.dart';
import 'package:flutter_atoms/models/navigation_page.dart';

typedef NavigationStateBuilderType = Future<void> Function(
    BuildContext context, AppNavigationState state);

class JetPage extends StatefulWidget {
  final String initialPageRoute;

  final AppNavigationState navigationState;

  JetPage(this.initialPageRoute, this.navigationState, {Key key})
      : super(key: key);

  @override
  _JetPageState createState() => _JetPageState();
}

class _JetPageState extends State<JetPage> {
  NavigationPage _page;

  InnerRouterDelegate _routerDelegate;

  final GlobalKey<State> bottomNavigationBarKey = GlobalKey<State>();
  BackButtonDispatcher _backButtonDispatcher;

  String _screenPath = "";

  NavBarCubit _navBarCubit;

  @override
  Widget build(BuildContext context) {
    try {
      _backButtonDispatcher.takePriority();
    } catch (ignore) {
    }
    _page.backButtonDispatcher = _backButtonDispatcher;


    return BlocProvider<NavBarCubit>(
      create: (_) => _navBarCubit,
      child: Scaffold(
        bottomNavigationBar: buildBottomNavigationBar(context),
        body: Router(
          routerDelegate: _routerDelegate,
          backButtonDispatcher: _backButtonDispatcher,
          routeInformationParser: widget.navigationState.navigationModel,
        )),
    );
  }

  Widget buildBottomNavigationBar(BuildContext context) {
    return BlocBuilder<NavBarCubit, NavBarState>(
      builder: (context, state) {
        var navigationModel = widget.navigationState.navigationModel;
        var buttons = _page
            .screenGroupsMap
            .values
            .where((group) => group.index >= 0 && group.buttonBuilder != null)
            .map<BottomNavigationBarItem>((e) => e.buttonBuilder(context))
            .toList();
        var _group = navigationModel
            .getScreenGroupByPath(state.path);
        if (buttons.length >= 2 && _group.index >= 0)
          return BottomNavigationBar(
              key: bottomNavigationBarKey,
              type: BottomNavigationBarType.fixed,
              currentIndex: _group.index,
              onTap: (index) {
                if (index == _group.index) return;
                var newGroup = navigationModel
                    .getPageByPath(widget.initialPageRoute)
                    .screenGroupsMap
                    .values
                    .toList()[index];
                _screenPath = newGroup.screenMaps.values.first.path;

                Navigator.of(_routerDelegate.navigatorKey.currentContext)
                    .pushNamed(_screenPath);
              },
              items: buttons);
        return Container();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _navBarCubit = NavBarCubit(widget.initialPageRoute);
    _routerDelegate =
        InnerRouterDelegate(
            widget.navigationState, widget.initialPageRoute, _navBarCubit);
    _page = widget.navigationState.navigationModel
        .getPageByPath(widget.initialPageRoute);
    _screenPath = widget.initialPageRoute;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Defer back button dispatching to the child router
    var rootBackDispatcher = Router
        .of(context)
        .backButtonDispatcher;
    _backButtonDispatcher = rootBackDispatcher
        .createChildBackButtonDispatcher();
  }
}

class InnerNavigatorObserver extends NavigatorObserver {
  final NavBarCubit navBarCubit;

  InnerNavigatorObserver(this.navBarCubit);

  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    navBarCubit.updatePath(route.settings.name);
  }

  @override
  void didReplace({Route<dynamic> newRoute, Route<dynamic> oldRoute}) {
    navBarCubit.updatePath(newRoute.settings.name);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    navBarCubit.updatePath(previousRoute.settings.name);
  }


}

class InnerRouterDelegate extends RouterDelegate<String>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<String> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final AppNavigationState state;

  final String pageRoute;

  InnerNavigatorObserver _innerNavigatorObserver;


  final NavBarCubit navBarCubit;

  final PageStorageBucket _bucket = PageStorageBucket();

  InnerRouterDelegate(this.state, this.pageRoute, this.navBarCubit) {
    _innerNavigatorObserver = InnerNavigatorObserver(navBarCubit);
  }

  Map<String, MaterialPageRoute> cache = {};

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      observers: [_innerNavigatorObserver],
      onGenerateInitialRoutes: (navigatorState, initialRoute) =>
      [
        buildRoute(context, initialRoute, state.navigationModel
            .getScreenByPath(initialRoute)
            .builder)
      ],

      onGenerateRoute: (settings) {
        var screen = state.navigationModel.getScreenByPath(settings.name);
        return buildRoute(
            context, screen.path, screen.builder, settings: settings);
      },
      initialRoute: pageRoute,
    );
  }


  @override
  Future<bool> popRoute() {
    return super.popRoute();
  }

  @override
  Future<void> setNewRoutePath(String path) async {
    assert(false);
    notifyListeners();
  }

  PageRoute buildRoute(BuildContext context, String route,
      WidgetBuilder screenBuilder, {RouteSettings settings}) =>
      MaterialPageRoute(
          settings: settings ?? RouteSettings(name: route),
          builder: (context) =>
              PageStorage(bucket: _bucket,
                  child: screenBuilder(context)));
}

class FadeAnimationPage extends Page {
  final Widget child;

  FadeAnimationPage({Key key, this.child}) : super(key: key);

  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (context, animation, animation2) {
        var curveTween = CurveTween(curve: Curves.easeIn);
        return FadeTransition(
          opacity: animation.drive(curveTween),
          child: child,
        );
      },
    );
  }
}
