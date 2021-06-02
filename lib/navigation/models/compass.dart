import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

import 'app_navigation_state.dart';
import 'navigators_register.dart';

@injectable
class Compass {
  static final loggerName = "Compass";
  final NavigatorsRegister navigatorsRegistry;
  final AppNavigationState appNavigationState;

  bool _root = false;
  bool _replace = false;
  String? path;

  bool _clear = false;
  bool _switchOn = true;



  Compass(@factoryParam this.path, this.navigatorsRegistry,
      this.appNavigationState);

  Compass root() {
    _root = true;
    return this;
  }

  Compass replace() {
    _replace = true;
    return this;
  }

  Compass switchOn() {
    _switchOn = true;
    return this;
  }

  Compass clear() {
    _clear = true;
    return this;
  }



  Future<T?> go<T>([Map<String, String>? params]) async {
    log("go to path $path, replace = $_replace, use root = $_root",
        name: loggerName);
    // var rootNavigator = navigatorsRegistry.getRoot().currentState;
    // if (rootNavigator == null) return Future.value(null);
    // var _currentPagePath = appNavigationState.currentPage.path;
    // log("currentPagePath $_currentPagePath", name: loggerName);
    // var _nextPagePath =
    //     appNavigationState.navigationModel.getPageByRoute(path!).path;
    // log("nextPagePath $_nextPagePath", name: loggerName);
    // NavigatorState? _operationNavigator;
    // if (_currentPagePath == _nextPagePath) {
    //   log("_currentPagePath == _nextPagePath", name: loggerName);
    //   _operationNavigator =
    //       navigatorsRegistry.get(_currentPagePath!).currentState;
    // } else {
    //   log("using root navigator", name: loggerName);
    //   _operationNavigator = rootNavigator;
    // }
    if (_clear) appNavigationState.history.clear();

    if (_replace) {
      appNavigationState.pop();
      appNavigationState.push(path!);
      // return _operationNavigator?.pushReplacementNamed(path!) as Future<T?>;
    }
    else {
      appNavigationState.push(path!);
      // return _operationNavigator?.pushNamed(path!) as Future<T?>;
    }

    appNavigationState.update();
    return Future<T?>.value();

  }

}
