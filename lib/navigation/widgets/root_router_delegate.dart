import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_atoms/logging.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../../navigation.dart';
import '../blocs/boot/boot_bloc.dart';
import '../models/navigators_register.dart';
import '../models/root_navigator_route_page.dart';
import 'root_navigator_observer.dart';

@singleton
class RootRouterDelegate extends RouterDelegate<String>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<String>, Loggable {
  final CompassNavigationState state;
  final Map<String, Widget> pageWidgets = {};
  final RootNavigatorObserver rootObserver;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  final NavigatorsRegister navigatorsRegister;

  RootRouterDelegate(this.state, this.rootObserver, this.navigatorsRegister) {
    navigatorsRegister.register("/", _navigatorKey);
    logger.finest("Creating root delegate");

    state.addListener(() {

      logger.finest("Notify AppNavigationState is called");
      notifyListeners();
    });
  }

  /// Build root [Navigator] widget using [CompassNavigationState] as history data.
  /// Instances of [Page] created with their names and route data.
  /// Also old fashion push approach is limited supported. Only push and pop operations.
  @override
  Widget build(BuildContext context) {
    logger.finest("build");
    logger.finest("${state.history}");

    Map<String, String> filteredHistory = <String, String>{};

    state.history.forEach((route) {
      var segments = Uri.parse(route).pathSegments;
      var firstSegment = segments.isNotEmpty ? "/${segments[0]}" : "/";
      filteredHistory.putIfAbsent(firstSegment, () => route);
    });

    logger.finest("filteredHistory $filteredHistory");

    var pages = filteredHistory.values.map((route) {
      logger.finest("map page $route");
      return RootNavigatorRoutePage(route, state,
          restorationId: route, key: ValueKey(route));
    }).toList();

    var navigator = Navigator(
      key: navigatorKey,
      pages: pages,
      onPopPage: (route, result) {
        logger.finest("Pop route ${route.settings.name}");
        if (route.didPop(result)) {
          route.settings.name?.compass().back(result);
          return true;
        }
        return false;
      },

      observers: [rootObserver],
      onGenerateRoute: (settings) {
        logger.finest("onGenerateRoute ${settings.name}");
       Router.of(context).backButtonDispatcher!.takePriority();
        // if (settings.name != null) settings.name!.go(settings.arguments as Map<String, dynamic>?);

        var screen = state.navigationModel.getScreenByRoute(settings.name!);
        var isJetPage = screen.path != screen.group.page.path;
        var _builder = isJetPage
            ? (dynamic context) => JetPage(settings.name!, state)
            : screen.builder!;
        return MaterialPageRoute(settings: settings, builder: _builder);
      },
//       onGenerateInitialRoutes: (NavigatorState navigator, String initialRoute) {
//         log("onGenerateInitialRoutes $initialRoute",
//             name: _loggerName);
//        Router.of(context).backButtonDispatcher!.takePriority();
//         var screen = state.navigationModel.getScreenByRoute(initialRoute);
//         var isJetPage = screen.path == screen.group.page.path;
//         var _builder = isJetPage
//             ? screen.builder!
//             : (dynamic context) => JetPage(screen.path, state);
//         notifyListeners();
//         return [
//           MaterialPageRoute(
//               settings: RouteSettings(name: initialRoute), builder: _builder)
//         ];
//       },
//       initialRoute: state.currentRoute,
    );
    return navigator;
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  @override
  Future<void> setNewRoutePath(String path) async {
    logger.finest("setNewRoutePath $path");

    if (GetIt.I<BootBloc>().state == BootBlocState.READY) {
      path.go();
    } else {
      path.compass().replace().go();
    }
    return SynchronousFuture<void>(null);
  }

  @override
  String get currentConfiguration {
    logger.finest("currentConfiguration call ${state.currentScreen.path}");
    return state.currentRoute;
  }
}
