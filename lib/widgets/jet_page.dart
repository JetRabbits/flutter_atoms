import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_atoms/blocs/blocs.dart';
import 'package:flutter_atoms/blocs/navigator/nav_bar_cubit.dart';
import 'package:flutter_atoms/models/app_navigation_state.dart';
import 'package:flutter_atoms/models/navigation_page.dart';
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
      {Key key,
        this.bottomNavigationHeight = 56,
        this.iconSize = 24,
        this.centerItemText = ''})
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

  BackButtonDispatcher _rootBackDispatcher;

  @override
  Widget build(BuildContext context) {
    try {
      _backButtonDispatcher.takePriority();
    } catch (ignore) {}
    _page.backButtonDispatcher = _backButtonDispatcher;

    return BlocProvider<NavBarCubit>(
      create: (_) => _navBarCubit,
      child: Scaffold(
          floatingActionButton: buildFloatActionButton(context),
          floatingActionButtonLocation: buildFloatActionButtonLocation(),
          bottomNavigationBar: buildBottomNavigationBar(context),
          body: Router(
            routerDelegate: _routerDelegate,
            backButtonDispatcher: _backButtonDispatcher,
            routeInformationParser: widget.navigationState.navigationModel,
          )),
    );
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
              widget.centerItemText ?? '',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(BottomNavigationBarItem item, ScreenGroup group) {
    var navigationModel = widget.navigationState.navigationModel;
    Color selectedColor = Theme
        .of(context)
        .accentColor;
    Color unselectedColor = Theme
        .of(context)
        .hintColor;

    var isActive =
        navigationModel.getScreenGroupByPath(_navBarCubit.state.path) == group;

    var _textStyle = Theme
        .of(context)
        .textTheme
        .bodyText1
        .copyWith(color: isActive ? selectedColor : unselectedColor);

    IconThemeData _iconThemeData = isActive
        ? IconThemeData(color: selectedColor)
        : IconThemeData(color: unselectedColor);


    var label = item.title ??
        AutoSizeText(
            item.label);

    return Expanded(
      child: SizedBox(
        height: widget.bottomNavigationHeight,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () {
              if (!isActive) {
                _screenPath = group.screenMaps.values.first.path;
                Navigator.of(_routerDelegate.navigatorKey.currentContext)
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
      builder: (context, state) {
        var navigationModel = widget.navigationState.navigationModel;
        var buttons = _page.screenGroupsMap.values
            .where((group) =>
        group.index >= 0 && group.navBarButtonBuilder != null)
            .map<Widget>(
                (g) => _buildTabItem(g.navBarButtonBuilder(context), g))
            .toList();
        if (_page.floatActionButtonConfig != null &&
            _page.floatActionButtonConfig.floatingActionButtonBuilder != null &&
            [
              FloatingActionButtonLocation.centerDocked,
              FloatingActionButtonLocation.miniCenterDocked
            ].contains(
                _page.floatActionButtonConfig.floatingActionButtonLocation)) {
          buttons.insert(buttons.length >> 1, _buildMiddleTabItem());
        }
        var _group = navigationModel.getScreenGroupByPath(state.path);
        if (buttons.length >= 2 && _group.index >= 0)
          return BottomAppBar(
              key: bottomNavigationBarKey,
              shape: CircularNotchedRectangle(),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: buttons,
              ));
        return Container();
      },
    );
  }

  Widget buildFloatActionButton(BuildContext context) {
    return _page.floatActionButtonConfig != null
        ? _page.floatActionButtonConfig.floatingActionButtonBuilder(context)
        : null;
  }

  FloatingActionButtonLocation buildFloatActionButtonLocation() {
    return _page.floatActionButtonConfig != null
        ? _page.floatActionButtonConfig.floatingActionButtonLocation
        : null;
  }

  @override
  void initState() {
    super.initState();
    _navBarCubit = NavBarCubit(widget.initialPageRoute);
    _routerDelegate = InnerRouterDelegate(
        widget.navigationState, widget.initialPageRoute, _navBarCubit);
    _page = widget.navigationState.navigationModel
        .getPageByPath(widget.initialPageRoute);
    _screenPath = widget.initialPageRoute;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Defer back button dispatching to the child router
    _rootBackDispatcher = Router
        .of(context)
        .backButtonDispatcher;
    _backButtonDispatcher =
        _rootBackDispatcher.createChildBackButtonDispatcher();
  }

  @override
  void dispose() {
    super.dispose();

    try {
      _rootBackDispatcher.forget(_backButtonDispatcher);
    } catch (e) {
    }
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
        buildRoute(context, initialRoute,
            state.navigationModel
                .getScreenByPath(initialRoute)
                .builder)
      ],
      onGenerateRoute: (settings) {
        var screen = state.navigationModel.getScreenByPath(settings.name);
        return buildRoute(context, screen.path, screen.builder,
            settings: settings);
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
      WidgetBuilder screenBuilder,
      {RouteSettings settings}) =>
      MaterialPageRoute(
          settings: settings ?? RouteSettings(name: route),
          builder: (context) =>
              PageStorage(bucket: _bucket, child: screenBuilder(context)));
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
