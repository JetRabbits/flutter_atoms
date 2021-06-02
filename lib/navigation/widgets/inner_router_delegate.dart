import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_atoms/navigation/models/navigators_register.dart';
import 'package:injectable/injectable.dart';

import '../navigation.dart';

@injectable
class InnerRouterDelegate extends RouterDelegate<String>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<String> {
  final AppNavigationState state;

  final String? initialRoute;

  late final InnerNavigatorObserver _innerNavigatorObserver;

  final NavBarCubit? navBarCubit;

  final PageStorageBucket _bucket = PageStorageBucket();

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  final NavigatorsRegister navigatorsRegister;

  static final _loggerName = 'InnerRouterDelegate';

  InnerRouterDelegate(@factoryParam this.initialRoute,
      @factoryParam this.navBarCubit, this.state, this.navigatorsRegister) {
    log("Creating with pageRoute = $initialRoute", name: _loggerName);
    _innerNavigatorObserver = InnerNavigatorObserver(navBarCubit!, state);
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

    return Navigator(
        key: navigatorKey,
        pages: state.history.where((route) {
          var routePage = state.navigationModel.getPageByRoute(route);
          var initialPage = state.navigationModel.getPageByRoute(initialRoute!);
          log("routePage ${routePage.path} == ${initialPage.path} ${routePage.path == initialPage.path}");
          return routePage.path == initialPage.path;
        }).map((route) {
          log("mapping route $route", name: _loggerName);
          var screen = state.navigationModel.getScreenByRoute(route);
          return SimpleRouteScreenPage(route, screen,
              name: route, restorationId: route);
        }).toList(),
        onPopPage: (route, result) {
          log("Pop route ${route.settings.name}", name: _loggerName);

          if (route.didPop(result)){
            state.pop();
            state.lastPopResult = result;
            state.update();
            return true;
          }
          return false;
        },
        observers: [_innerNavigatorObserver],
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
  String get currentConfiguration {
    log("currentConfiguration call ${state.currentRoute}", name: _loggerName);
    return state.currentRoute;
  }

  @override
  Future<void> setNewRoutePath(String path) async {
    log("setNewRoutePath $path", name: _loggerName);
  }

  PageRoute buildRoute(
      BuildContext context, String route, WidgetBuilder? screenBuilder,
      {RouteSettings? settings}) {
    notifyListeners();
    return MaterialPageRoute(
        settings: settings ?? RouteSettings(name: route),
        builder: (context) => screenBuilder!(context));
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;
}
