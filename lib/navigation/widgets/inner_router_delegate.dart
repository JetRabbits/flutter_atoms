import 'package:flutter/material.dart';
import 'package:flutter_atoms/logging.dart';
import 'package:flutter_atoms/navigation/observers/inner_navigation_observer.dart';
import 'package:injectable/injectable.dart';

import '../../navigation.dart';
import '../models/compass_navigation_state.dart';
import '../models/inner_navigator_route_page.dart';

@injectable
class InnerRouterDelegate extends RouterDelegate<String>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<String>, Loggable {
  late CompassNavigationState state;

  late String? initialRoute;

  late NavBarCubit navBarCubit;

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  late void Function() _listener;

  late InnerNavigatorObserver innerNavigatorObserver;

  InnerRouterDelegate();

  void configure(CompassNavigationState state, String initialRoute,
      NavBarCubit navBarCubit, InnerNavigatorObserver innerNavigatorObserver) {
    logger.finest("Configuring with initialRoute = $initialRoute");
    this.state = state;
    this.initialRoute = initialRoute;
    this.navBarCubit = navBarCubit;
    this.innerNavigatorObserver = innerNavigatorObserver;
    _listener = () {
      logger.finest("Notify AppNavigationState is called");
      notifyListeners();
      this.navBarCubit.updatePath(state.currentRoute);
    };
    this.state.addListener(_listener);
  }

  @override
  void dispose() {
    logger.finest("dispose");
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
      logger.finest(
          "routePage ${routePage.path} == ${initialPage.path} ${routePage.path == initialPage.path}");
      if (routePage.path == initialPage.path) {
        logger.finest("mapping route $route");
        var screen = state.navigationModel.getScreenByRoute(route);
        result.remove(route);
        result[route] = InnerNavigatorRoutePage(screen,
            name: route, restorationId: route, key: ValueKey(route));
      }
    });

    var _pages = result.values.toList();
    List<NavigatorObserver> observers = [innerNavigatorObserver];
    if (state.navigationModel.observersBuilder != null) {
      observers.addAll(state.navigationModel.observersBuilder!());
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
          return MaterialPageRoute(
              builder: (context) => screen.builder!(context),
              settings: settings);
        });
  }

  @override
  Future<void> setNewRoutePath(String path) async {}

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;
}
