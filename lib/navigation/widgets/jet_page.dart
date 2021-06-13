import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../navigation.dart';
import 'inner_router_delegate.dart';

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

  InnerRouterDelegate? _innerRouterDelegate;

  final GlobalKey<State> bottomNavigationBarKey = GlobalKey<State>();
  BackButtonDispatcher? _backButtonDispatcher;

  String _screenPath = "";

  late NavBarCubit _navBarCubit;

  BackButtonDispatcher? _rootBackDispatcher;

  late NavigationScreen _screen;

  static final _loggerName = 'JetPage';

  @override
  Widget build(BuildContext context) {
    log("build", name: _loggerName);

    if (_innerRouterDelegate == null) {
      log("no inner navigator", name: _loggerName);
      var screenWidget = _screen.builder!(context);
      if (screenWidget is Scaffold) {
        return screenWidget;
      }
      return Scaffold(body: screenWidget);
    }

    log("with inner navigator", name: _loggerName);

    // try {
    //   _backButtonDispatcher!.takePriority();
    // } catch (ignore) {}
    // _page.backButtonDispatcher = _backButtonDispatcher;

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
                routerDelegate: _innerRouterDelegate!,
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
        navigationModel.getScreenGroupByRoute(_navBarCubit.state.path) == group;

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
                _screenPath.go();
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

  NavigationRailDestination _buildSideBarButton(
      NavigationRailDestinationBuilder builder, ScreenGroup group) {
    return builder(context);
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
        var _group = navigationModel.getScreenGroupByRoute(state.path);
        if (buttons.length >= 2 && _group.navBarIndex >= 0)
          return BottomAppBar(
              elevation: 0,
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
                (g) => _buildSideBarButton(g.sideBarButtonBuilder!, g))
            .toList();
        var _group = navigationModel.getScreenGroupByRoute(state.path);
        if (buttons.length >= 2 && _group.sideBarIndex >= 0)
          return NavigationRail(
              leading: navigationModel.sideBarLogo,
              onDestinationSelected: (value) {
                var _screenGroup = _page.screenGroupsMap.values
                    .firstWhereOrNull((g) => g.sideBarIndex == value);
                if (_screenGroup != null) {
                  var _path = _screenGroup.screenMaps.values.first.path;
                  _path.go();
                }
              },
              extended: MediaQuery.of(context).size.width > 1024,
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
    log("initialPageRoute = ${widget.initialPageRoute}", name: "JetPage");

    _page = widget.navigationState.navigationModel
        .getPageByRoute(widget.initialPageRoute);
    _screenPath = widget.initialPageRoute;
    _screen = widget.navigationState.currentScreen;

    if (_screen.path != _page.path) {
      _navBarCubit = NavBarCubit(widget.initialPageRoute);
      _innerRouterDelegate = GetIt.I<InnerRouterDelegate>(
          param1: widget.initialPageRoute, param2: _navBarCubit);
    }
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
  final NavBarCubit navBarCubit;

  final AppNavigationState state;

  InnerNavigatorObserver(this.navBarCubit, this.state);

  void _update(Route<dynamic> route) {
    var routePath = route.settings.name;
    if (routePath != null) {
      // state.currentRoute = routePath;
      navBarCubit.updatePath(routePath);
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _update(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _update(newRoute!);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _update(route);
  }
}

class SimpleRouteScreenPage extends Page {
  final NavigationScreen screen;
  final PageStorageBucket? storageBucket;

  final String route;

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
        settings: this,
        builder: (context) => storageBucket == null
            ? screen.builder!(context)
            : PageStorage(
                bucket: storageBucket!, child: screen.builder!(context)));
  }

  SimpleRouteScreenPage(
    this.route,
    this.screen,
    {
    this.storageBucket,
    String? name,
    Object? arguments,
    restorationId,
  }) : super(key: null, name: name, arguments: arguments);
}

class NavigableRoutePage extends Page {
  final PageStorageBucket? storageBucket;

  final String route;

  final AppNavigationState state;

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
        settings: this,
        builder: (context) {
          var widget = JetPage(route, state);

          return storageBucket == null
            ? widget
            : PageStorage(
                bucket: storageBucket!, child: widget);
        });
  }


  NavigableRoutePage(
    this.route,
    this.state,
    {
    this.storageBucket,
    Object? arguments,
    restorationId,
  }) : super(key: ValueKey(route), name: route, arguments: arguments);
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