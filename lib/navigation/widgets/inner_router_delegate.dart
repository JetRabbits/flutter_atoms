
import 'package:flutter/material.dart';
import 'package:flutter_atoms/logging.dart';
import 'package:injectable/injectable.dart';

import '../../navigation.dart';
import '../models/compass_navigation_state.dart';
import '../models/inner_navigator_route_page.dart';
import '../models/navigators_register.dart';

@injectable
class InnerRouterDelegate extends RouterDelegate<String>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<String>, Loggable {
  final CompassNavigationState state;

  final String? initialRoute;

  final NavBarCubit? navBarCubit;

  // final PageStorageBucket _bucket = PageStorageBucket();

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  final NavigatorsRegister navigatorsRegister;
  
  late void Function() _listener;

  InnerRouterDelegate(@factoryParam this.initialRoute,
      @factoryParam this.navBarCubit, this.state, this.navigatorsRegister) {
    logger.finest("Creating with pageRoute = $initialRoute");
    navigatorsRegister.register(this.initialRoute!, _navigatorKey);
    _listener =  () {
      logger.finest("Notify AppNavigationState is called");
      notifyListeners();
      navBarCubit?.updatePath(state.currentRoute);
    };
    state.addListener(_listener);
  }


  @override
  void dispose() {
    super.dispose();
    state.removeListener(_listener);
  }

  @override
  Widget build(BuildContext context) {
    logger.finest("build");
    logger.finest("${state.history}");
    logger.finest("current route = ${state.currentRoute}");
    logger.finest("current screen = ${state.currentScreen.path}");
    Map<String, InnerNavigatorRoutePage> result = {};

    state.history.forEach((route) {
      var routePage = state.navigationModel.getPageByRoute(route);
      var initialPage = state.navigationModel.getPageByRoute(initialRoute!);
      logger.finest("routePage ${routePage.path} == ${initialPage.path} ${routePage.path == initialPage.path}");
      if (routePage.path == initialPage.path) {
        logger.finest("mapping route $route");
        var screen = state.navigationModel.getScreenByRoute(route);
        result.remove(route);
        result[route] = InnerNavigatorRoutePage(screen,
            name: route, restorationId: route, key: ValueKey(route));
      }
    });

    var _pages = result.values.toList();
    List<NavigatorObserver> observers = [InnerNavigatorObserver(navBarCubit!)];
    if (state.navigationModel.observers != null){
      observers.addAll(state.navigationModel.observers!);
    }

    return Navigator(
      key: navigatorKey,
      pages: _pages,
      onPopPage: (route, result) {
        logger.finest("Pop route ${route.settings.name}");

        if (route.didPop(result)) {
          route.settings.name?.compass().back(result);
          return true;
        }
        return false;
      },
      observers: observers,
      // onGenerateInitialRoutes: (navigatorState, initialRoute) {
      //   log('onGenerateInitialRoutes $initialRoute', name: _loggerName);
      //   return [
      //     buildRoute(context, initialRoute,
      //         state.navigationModel.getScreenByRoute(initialRoute).builder)
      //   ];
      // },
      // initialRoute: initialRoute,
      onGenerateRoute: (settings) {
        logger.finest('onGenerateRoute ${settings.name}');
        Router.of(context).backButtonDispatcher!.takePriority();
        var screen = state.navigationModel.getScreenByRoute(settings.name!);
        return MaterialPageRoute(builder: (context) => screen.builder!(context), settings: settings);
      }
    );
  }

  @override
  Future<void> setNewRoutePath(String path) async {
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;
}


class InnerNavigatorObserver extends NavigatorObserver with Loggable{
  NavBarCubit navbarCubit;

  InnerNavigatorObserver(this.navbarCubit);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    logger.finest("didPush");
    _update(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    logger.finest("didReplace");
    _update(newRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    logger.finest("didPop");
    _update(previousRoute);
  }

  void _update(Route<dynamic>? route) {
    if (route != null)
      navbarCubit.updatePath(route.settings.name);
  }
}
