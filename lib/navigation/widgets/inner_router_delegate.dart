import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_atoms/navigation/models/inner_navigator_route_creator.dart';
import 'package:flutter_atoms/navigation/models/navigators_register.dart';
import 'package:injectable/injectable.dart';

import '../../navigation.dart';

@injectable
class InnerRouterDelegate extends RouterDelegate<String>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<String> {
  final AppNavigationState state;

  final String? initialRoute;

  final NavBarCubit? navBarCubit;

  final PageStorageBucket _bucket = PageStorageBucket();

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  final NavigatorsRegister navigatorsRegister;

  static final _loggerName = 'InnerRouterDelegate';

  InnerRouterDelegate(@factoryParam this.initialRoute,
      @factoryParam this.navBarCubit, this.state, this.navigatorsRegister) {
    log("Creating with pageRoute = $initialRoute", name: _loggerName);
    navigatorsRegister.register(this.initialRoute!, _navigatorKey);
    state.addListener(() {
      log("Notify AppNavigationState is called", name: _loggerName);
      notifyListeners();
    });
  }

  @override
  Widget build(BuildContext context) {
    log("build", name: _loggerName);
    log("${state.history}", name: _loggerName);
    log("current route = ${state.currentRoute}", name: _loggerName);
    log("current screen = ${state.currentScreen.path}", name: _loggerName);
    Map<String, InnerNavigatorRouteCreator> result = {};
    state.history.forEach((route) {
      var routePage = state.navigationModel.getPageByRoute(route);
      var initialPage = state.navigationModel.getPageByRoute(initialRoute!);
      log("routePage ${routePage.path} == ${initialPage.path} ${routePage.path == initialPage.path}");
      if (routePage.path == initialPage.path) {
        log("mapping route $route", name: _loggerName);
        var screen = state.navigationModel.getScreenByRoute(route);
        result.remove(route);
        result[route] = InnerNavigatorRouteCreator(route, screen,
            name: route, restorationId: route, key: ValueKey(route));
      }
    });

    var _pages = result.values.toList();
    return Navigator(
      key: navigatorKey,
      pages: _pages,
      onPopPage: (route, result) {
        log("Pop route ${route.settings.name}", name: _loggerName);

        if (route.didPop(result)) {
          state.pop();
          state.lastPopResult = result;
          state.update();
          return true;
        }
        return false;
      },
      // onGenerateInitialRoutes: (navigatorState, initialRoute) {
      //   log('onGenerateInitialRoutes $initialRoute', name: _loggerName);
      //   return [
      //     buildRoute(context, initialRoute,
      //         state.navigationModel.getScreenByRoute(initialRoute).builder)
      //   ];
      // },
      // initialRoute: initialRoute,
      // onGenerateRoute: (settings) {
      //   log('onGenerateRoute ${settings.name}', name: _loggerName);
      //   Router.of(context).backButtonDispatcher!.takePriority();
      //   var screen = state.navigationModel.getScreenByRoute(settings.name!);
      //   return buildRoute(context, screen.path, screen.builder,
      //       settings: settings);
      // }
    );
  }

  @override
  Future<void> setNewRoutePath(String path) async {
    // log('setNewRoutePath', name: _loggerName);
    // notifyListeners();
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;
}
