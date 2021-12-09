
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_atoms/logging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../navigation.dart';
import 'inner_router_delegate.dart';

typedef NavigationStateBuilderType = Future<void> Function(
    BuildContext context, CompassNavigationState state);

class JetPage extends StatefulWidget {
  final String initialPageRoute;
  final double bottomNavigationHeight;

  final CompassNavigationState navigationState;

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

class _JetPageState extends State<JetPage> with Loggable {
  late NavigationPage _page;

  InnerRouterDelegate? _innerRouterDelegate;

  final GlobalKey<State> bottomNavigationBarKey = GlobalKey<State>();
  BackButtonDispatcher? _backButtonDispatcher;

  String _screenPath = "";

  late NavBarCubit _navBarCubit;

  BackButtonDispatcher? _rootBackDispatcher;

  late NavigationScreen _screen;

  late CompassNavigationState _navigationState;

  @override
  Widget build(BuildContext context) {
    logger.finest("build");

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
                routerDelegate: _innerRouterDelegate!,
                backButtonDispatcher: _backButtonDispatcher,
                routeInformationParser: widget.navigationState.navigationModel,
                routeInformationProvider:
                    widget.navigationState.routeInformationProvider,
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
    var navigationState = widget.navigationState;
    Color selectedColor = Theme
        .of(context)
        .colorScheme
        .secondary;
    Color unselectedColor = Theme
        .of(context)
        .hintColor;

    var isActive = navigationState.currentScreenGroup == group;

    var _textStyle = Theme
        .of(context)
        .textTheme
        .bodyText1!
        .copyWith(color: isActive ? selectedColor : unselectedColor);

    IconThemeData _iconThemeData = isActive
        ? IconThemeData(color: selectedColor)
        : IconThemeData(color: unselectedColor);

    Widget? label;
    if (item.label != null || item.title != null)
      label = item.title ??
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
                _screenPath.compass().go();
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                isActive
                    ? IconTheme(data: _iconThemeData, child: item.activeIcon)
                    : IconTheme(data: _iconThemeData, child: item.icon),
                if (label != null) DefaultTextStyle.merge(
                    style: _textStyle, child: label),
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
        if (buttons.length >= 2 && _group.navBarIndex >= 0) {
          var titleText = '';
          if (navigationModel.onTitleText != null) {
            titleText = navigationModel.onTitleText!(context, state.path);
          }
          var titleColor = Colors.white;
          if (navigationModel.onTitleColor != null) {
            titleColor = navigationModel.onTitleColor!(context, state.path);
          }
          return Title(
            title: titleText,
            color: titleColor,
            child: BottomAppBar(
                elevation: 0,
                key: bottomNavigationBarKey,
                clipBehavior: Clip.antiAlias,
                shape: CircularNotchedRectangle(),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: buttons,
                )),
          );
        }
        return Container();
      },
    );
  }

  Widget buildSideBar(BuildContext context) {
    return BlocBuilder<NavBarCubit, NavBarState>(
      bloc: _navBarCubit,
    builder: (context, state)
    {
      var navigationModel = widget.navigationState.navigationModel;
      var buttons = _page.screenGroupsMap.values
          .where((group) =>
      group.sideBarIndex >= 0 && group.sideBarButtonBuilder != null)
          .map<NavigationRailDestination>(
              (g) => _buildSideBarButton(g.sideBarButtonBuilder!, g))
          .toList();
      var _group = navigationModel
          .getScreenGroupByRoute(widget.navigationState.currentRoute);
      if (buttons.length >= 2 && _group.sideBarIndex >= 0) {
        var titleText = '';
        if (navigationModel.onTitleText != null) {
          titleText = navigationModel.onTitleText!(context, state.path);
        }
        var titleColor = Colors.white;
        if (navigationModel.onTitleColor != null) {
          titleColor = navigationModel.onTitleColor!(context, state.path);
        }
        return Title(
          title: titleText,
          color: titleColor,
          child: NavigationRail(
              trailing: navigationModel.sideBarFooter != null ? navigationModel.sideBarFooter!(context): null,
              leading: navigationModel.sideBarLogo != null ? navigationModel.sideBarLogo!(context): null,
              onDestinationSelected: (value) {
                var _screenGroup = _page.screenGroupsMap.values
                    .firstWhereOrNull((g) => g.sideBarIndex == value);
                if (_screenGroup != null) {
                  var _path = _screenGroup.screenMaps.values.first.path;
                  _path.compass().go();
                }
              },
              extended: MediaQuery
                  .of(context)
                  .size
                  .width > 1024,
              destinations: buttons,
              selectedIndex: _group.sideBarIndex),
        );
      }
      return Container();
    });
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
    logger.finest("initialPageRoute ${widget.initialPageRoute}");

    _page = widget.navigationState.navigationModel
        .getPageByRoute(widget.initialPageRoute);
    _screenPath = widget.initialPageRoute;
    _navigationState = widget.navigationState;
    _screen = _navigationState.navigationModel.getScreenByRoute(_screenPath);
    if (_screen.path != _page.path) {
      _navBarCubit = NavBarCubit(widget.initialPageRoute);
      _innerRouterDelegate = GetIt.I<InnerRouterDelegate>(
          param1: widget.initialPageRoute, param2: _navBarCubit);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    logger.finest("didChangeDependencies");

    // Defer back button dispatching to the child router
    if (_rootBackDispatcher == null) {
      _rootBackDispatcher = Router
          .of(context)
          .backButtonDispatcher;
      _backButtonDispatcher =
          _rootBackDispatcher!.createChildBackButtonDispatcher();
    }
  }

  @override
  void dispose() {
    super.dispose();
    logger.finest("dispose");
    _innerRouterDelegate?.dispose();


    try {
      _rootBackDispatcher!
          .forget(_backButtonDispatcher as ChildBackButtonDispatcher);
    } catch (e) {}
  }
}

class InnerNavigatorObserver extends NavigatorObserver with Loggable{
  final NavBarCubit navBarCubit;

  final CompassNavigationState state;

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
    logger.finest("didPush");
    _update(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    logger.finest("didReplace");
    _update(newRoute!);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    logger.finest("didPop");
    _update(route);
  }
}
