import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_atoms/navigation/models/navigators_register.dart';
import 'package:injectable/injectable.dart';

import '../navigation.dart';
import 'root_navigator_observer.dart';

@injectable
class RootRouterDelegate extends RouterDelegate<String>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<String> {
  final AppNavigationState state;
  final Map<String, Widget> pageWidgets = {};
  final RootNavigatorObserver rootObserver;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  final NavigatorsRegister navigatorsRegister;

  static final _loggerName = "JetAppRouterDelegate";

  RootRouterDelegate(this.state, this.rootObserver, this.navigatorsRegister) {
    navigatorsRegister.register("/", _navigatorKey);
    state.addListener(() {
      log("Notify AppNavigationState is called", name: _loggerName);
      notifyListeners();
    });
  }

  @override
  Widget build(BuildContext context) {
    log("build", name: _loggerName);
    log("${state.history}", name: _loggerName);

    Map<String, String> filteredHistory = <String, String>{};

    state.history.forEach((route) {
      var segments = Uri.parse(route).pathSegments;
      var firstSegment = segments.isNotEmpty ? "/${segments[0]}" : "/";
      filteredHistory.putIfAbsent(firstSegment, () => route);
    });

    log("filteredHistory $filteredHistory", name: _loggerName);

    var pages = filteredHistory.values.map((route) {
      log("map page $route", name: _loggerName);
      return NavigableRoutePage(route, state,
          restorationId: route);
    }).toList();

    var navigator = Navigator(
      key: navigatorKey,
      pages: pages,
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

      observers: [rootObserver],
//       onGenerateRoute: (settings) {
//         log("onGenerateRoute ${settings.name}", name: _loggerName);
// //        Router.of(context).backButtonDispatcher!.takePriority();
//         var screen = state.navigationModel.getScreenByRoute(settings.name!);
//         var isJetPage = screen.path == screen.group.page.path;
//         var _builder = isJetPage
//             ? screen.builder!
//             : (dynamic context) => JetPage(settings.name!, state);
//         notifyListeners();
//         return MaterialPageRoute(settings: settings, builder: _builder);
//       },
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
  // TODO: implement navigatorKey
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  @override
  Future<void> setNewRoutePath(String path) async {
    log("setNewRoutePath $path", name: _loggerName);
    path.compass().replace().go();
  }

  @override
  String get currentConfiguration {
    log("currentConfiguration call ${state.currentScreen.path}",
        name: _loggerName);
    return state.currentRoute;
  }
}