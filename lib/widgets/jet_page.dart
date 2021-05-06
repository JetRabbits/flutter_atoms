import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_atoms/blocs/blocs.dart';
import 'package:flutter_atoms/blocs/navigator/nav_bar_cubit.dart';
import 'package:flutter_atoms/models/app_navigation_state.dart';
import 'package:flutter_atoms/models/navigation_page.dart';
import 'package:flutter_atoms/models/navigation_screen.dart';
import 'package:flutter_atoms/models/screen_group.dart';

typedef NavigationStateBuilderType = Future<void> Function(
    BuildContext context, AppNavigationState state);

class JetPage extends StatefulWidget {
  final String initialPageRoute;
  final double bottomNavigationHeight;

  final AppNavigationState navigationState;

  final double iconSize;

  final String centerItemText;

  JetPage(this.initialPageRoute, this.navigationState,
      {Key? key,
      this.bottomNavigationHeight = kBottomNavigationBarHeight,
      this.iconSize = 24,
      this.centerItemText = ''})
      : super(key: key);

  @override
  _JetPageState createState() => _JetPageState();
}

class _JetPageState extends State<JetPage> {
  late NavigationPage _page;

  late InnerRouterDelegate _routerDelegate;

  final GlobalKey<State> bottomNavigationBarKey = GlobalKey<State>();
  BackButtonDispatcher? _backButtonDispatcher;

  String _screenPath = "";

  late NavBarCubit _navBarCubit;

  BackButtonDispatcher? _rootBackDispatcher;

  @override
  Widget build(BuildContext context) {
    try {
      _backButtonDispatcher!.takePriority();
    } catch (ignore) {}
    _page.backButtonDispatcher = _backButtonDispatcher;

    return Scaffold(
        extendBody: true,
        floatingActionButton: buildFloatActionButton(context),
        floatingActionButtonLocation: buildFloatActionButtonLocation(),
        bottomNavigationBar: buildBottomNavigationBar(context),
        body: Row(
          children: [
            buildSideBar(context),
//            VerticalDivider(),
            Expanded(
              child: Router(
                routerDelegate: _routerDelegate,
                backButtonDispatcher: _backButtonDispatcher,
                routeInformationParser: widget.navigationState.navigationModel,
                routeInformationProvider: PlatformRouteInformationProvider(
                    initialRouteInformation:
                        RouteInformation(location: widget.initialPageRoute)),
              ),
            ),
          ],
        ));
  }

  Widget _buildMiddleTabItem() {
    return Expanded(
      child: SizedBox(
        height: widget.bottomNavigationHeight,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: widget.iconSize),
            Text(
              widget.centerItemText,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(BottomNavigationBarItem item, ScreenGroup group) {
    var navigationModel = widget.navigationState.navigationModel;
    Color selectedColor = Theme.of(context).accentColor;
    Color unselectedColor = Theme.of(context).hintColor;

    var isActive =
        navigationModel.getScreenGroupByPath(_navBarCubit.state.path) == group;

    var _textStyle = Theme.of(context)
        .textTheme
        .bodyText1!
        .copyWith(color: isActive ? selectedColor : unselectedColor);

    IconThemeData _iconThemeData = isActive
        ? IconThemeData(color: selectedColor)
        : IconThemeData(color: unselectedColor);

    var label = item.title ??
        Text(
          item.label!,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        );

    return Expanded(
      child: SizedBox(
        height: widget.bottomNavigationHeight,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () {
              if (!isActive) {
                _screenPath = group.screenMaps.values.first.path;
                Navigator.of(_routerDelegate.navigatorKey.currentContext!)
                    .pushNamed(_screenPath);
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                isActive
                    ? IconTheme(data: _iconThemeData, child: item.activeIcon)
                    : IconTheme(data: _iconThemeData, child: item.icon),
                DefaultTextStyle.merge(style: _textStyle, child: label),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBottomNavigationBar(BuildContext context) {
    return BlocBuilder<NavBarCubit, NavBarState>(
      bloc: _navBarCubit,
      builder: (context, state) {
        var navigationModel = widget.navigationState.navigationModel;
        var buttons = _page.screenGroupsMap.values
            .where((group) =>
                group.navBarIndex >= 0 && group.navBarButtonBuilder != null)
            .map<Widget>(
                (g) => _buildTabItem(g.navBarButtonBuilder!(context), g))
            .toList();
        if (_page.floatActionButtonConfig != null &&
            [
              FloatingActionButtonLocation.centerDocked,
              FloatingActionButtonLocation.miniCenterDocked
            ].contains(
                _page.floatActionButtonConfig!.floatingActionButtonLocation)) {
          buttons.insert(buttons.length >> 1, _buildMiddleTabItem());
        }
        var _group = navigationModel.getScreenGroupByPath(state.path);
        if (buttons.length >= 2 && _group.navBarIndex >= 0)
          return BottomAppBar(
              key: bottomNavigationBarKey,
              clipBehavior: Clip.antiAlias,
              shape: CircularNotchedRectangle(),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: buttons,
              ));
        return Container();
      },
    );
  }

  Widget buildSideBar(BuildContext context) {
    return BlocBuilder<NavBarCubit, NavBarState>(
      bloc: _navBarCubit,
      builder: (context, state) {
        var navigationModel = widget.navigationState.navigationModel;
        var buttons = _page.screenGroupsMap.values
            .where((group) =>
                group.sideBarIndex >= 0 && group.sideBarButtonBuilder != null)
            .map<NavigationRailDestination>(
                (g) => g.sideBarButtonBuilder!(context))
            .toList();
        var _group = navigationModel.getScreenGroupByPath(state.path);
        if (buttons.length >= 2 && _group.sideBarIndex >= 0)
          return NavigationRail(
            destinations: buttons,
            selectedIndex: _group.sideBarIndex);
        return Container();
      },
    );
  }

  Widget? buildFloatActionButton(BuildContext context) {
    return _page.floatActionButtonConfig != null
        ? _page.floatActionButtonConfig!.floatingActionButtonBuilder(context)
        : null;
  }

  FloatingActionButtonLocation? buildFloatActionButtonLocation() {
    return _page.floatActionButtonConfig != null
        ? _page.floatActionButtonConfig!.floatingActionButtonLocation
        : null;
  }

  @override
  void initState() {
    super.initState();
    developer.log("initialPageRoute = ${widget.initialPageRoute}", name: "JetPage");
    _navBarCubit = NavBarCubit(widget.initialPageRoute);
    _routerDelegate = InnerRouterDelegate(
        widget.navigationState, widget.navigationState.currentScreen.path, _navBarCubit);
    _page = widget.navigationState.navigationModel
        .getPageByPath(widget.initialPageRoute);
    _screenPath = widget.initialPageRoute;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Defer back button dispatching to the child router
    if (_rootBackDispatcher == null) {
      _rootBackDispatcher = Router.of(context).backButtonDispatcher;
      _backButtonDispatcher =
          _rootBackDispatcher!.createChildBackButtonDispatcher();
    }
  }

  @override
  void dispose() {
    super.dispose();

    try {
      _rootBackDispatcher!
          .forget(_backButtonDispatcher as ChildBackButtonDispatcher);
    } catch (e) {}
  }
}

class InnerNavigatorObserver extends NavigatorObserver {
  final NavBarCubit? navBarCubit;

  InnerNavigatorObserver(this.navBarCubit);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    navBarCubit!.updatePath(route.settings.name);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    navBarCubit!.updatePath(newRoute!.settings.name);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    navBarCubit!.updatePath(previousRoute!.settings.name);
  }
}

class JetNavPage extends Page {

  final NavigationScreen screen;
  final PageStorageBucket storageBucket;

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
        settings: this,
        builder: (context) =>
            PageStorage(bucket: storageBucket, child: screen.builder!(context)));
  }

  JetNavPage(this.screen, this.storageBucket, {
    key,
    String? name,
    Object? arguments,
    restorationId,
  }) : super(key: key, name: name, arguments: arguments);
}

class InnerRouterDelegate extends RouterDelegate<String>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<String> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final AppNavigationState state;

  final String pageRoute;

  InnerNavigatorObserver? _innerNavigatorObserver;

  final NavBarCubit? navBarCubit;

  final PageStorageBucket _bucket = PageStorageBucket();

  InnerRouterDelegate(this.state, this.pageRoute, this.navBarCubit) {
    _innerNavigatorObserver = InnerNavigatorObserver(navBarCubit);
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      observers: [_innerNavigatorObserver!],
      pages: state.historyRoutes.map<Page>((path) {
        var screen = state.navigationModel.getScreenByPath(path);
        return JetNavPage(screen, _bucket, name: screen.path);
      }).toList(),
//        onGenerateInitialRoutes: (navigatorState, initialRoute) =>
//        [
//          buildRoute(context, initialRoute,
//              state.navigationModel
//                  .getScreenByPath(initialRoute)
//                  .builder)
//        ],
        onGenerateRoute: (settings) {
          Router.of(context).backButtonDispatcher!.takePriority();
          var screen = state.navigationModel.getScreenByPath(settings.name!);
          state.push(screen.path);
          notifyListeners();
          return buildRoute(context, screen.path, screen.builder,
              settings: settings);
        },
      onPopPage: (Route<dynamic> route, dynamic result) {
        developer.log("onPopPage call ${route.settings.name}", name: "InnerRouterDelegate");
        if (!route.didPop(result)) {
          return false;
        }
        state.pop();
        notifyListeners();
        return true;
      },
    );
  }

  @override
  String get currentConfiguration {
    developer.log("currentConfiguration call ${state.currentScreen.path}", name: "InnerRouterDelegate");
    return state.currentScreen.path;
  }

  @override
  Future<void> setNewRoutePath(String path) async {
    developer.log("setNewRoutePath $path", name: "InnerRouterDelegate");
    state.push(path);
    notifyListeners();
  }

  PageRoute buildRoute(
          BuildContext context, String route, WidgetBuilder? screenBuilder,
          {RouteSettings? settings}) =>
      MaterialPageRoute(
          settings: settings ?? RouteSettings(name: route),
          builder: (context) =>
              PageStorage(bucket: _bucket, child: screenBuilder!(context)));
}

class FadeAnimationPage extends Page {
  final Widget? child;

  FadeAnimationPage({Key? key, this.child}) : super(key: key as LocalKey?);

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
