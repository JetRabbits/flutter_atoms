import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_atoms/navigation/models/navigators_register.dart';
import 'package:injectable/injectable.dart';

import '../navigation.dart';
import 'package:get_it/get_it.dart';
import 'root_navigator_observer.dart';

@injectable
class JetAppRouterDelegate extends RouterDelegate<String>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<String> {
  final AppNavigationState state;
  final Map<String, Widget> pageWidgets = {};
  final RootNavigatorObserver rootObserver;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  final NavigatorsRegister navigatorsRegister;

  static final _loggerName = "JetAppRouterDelegate";

  JetAppRouterDelegate(this.state, this.rootObserver, this.navigatorsRegister) {
    navigatorsRegister.register("/", _navigatorKey);
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      observers: [rootObserver],
      onGenerateRoute: (settings) {
        developer.log("onGenerateRoute ${settings.name}",
            name: _loggerName);
//        Router.of(context).backButtonDispatcher!.takePriority();
        var screen = state.navigationModel.getScreenByPath(settings.name!);
        var isJetPage = screen.path == screen.group.page.path;
        var _builder = isJetPage
            ? screen.builder!
            : (dynamic context) => JetPage(screen.path, state);
        return MaterialPageRoute(settings: settings, builder: _builder);
      },
      onGenerateInitialRoutes: (NavigatorState navigator, String initialRoute) {
        developer.log("onGenerateInitialRoutes ${initialRoute}",
            name: _loggerName);
//        Router.of(context).backButtonDispatcher!.takePriority();
        var screen = state.navigationModel.getScreenByPath(initialRoute);
        var isJetPage = screen.path == screen.group.page.path;
        var _builder = isJetPage
            ? screen.builder!
            : (dynamic context) => JetPage(screen.path, state);
        return [MaterialPageRoute(settings: RouteSettings(name: initialRoute), builder: _builder)];
      },
      initialRoute: state.currentScreen.path,
    );
  }

  @override
  // TODO: implement navigatorKey
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  @override
  Future<void> setNewRoutePath(String path) async {
    developer.log("setNewRoutePath $path", name: _loggerName);
    state.push(path);
    notifyListeners();
  }

  @override
  String get currentConfiguration {
    developer.log("currentConfiguration call ${state.currentScreen.path}",
        name: _loggerName);
    return state.currentScreen.path;
  }
}
