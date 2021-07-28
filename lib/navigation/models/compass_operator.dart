import 'dart:developer';

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import 'compass_navigation_state.dart';
import 'navigators_register.dart';

@injectable
class CompassOperator {
  static final _logger = Logger('CompassOperator');
  final NavigatorsRegister navigatorsRegistry;
  final CompassNavigationState state;
  late String path;

  bool _root = false;
  bool _replace = false;

  bool _clear = false;
  bool _switchOn = false;


  CompassOperator(@factoryParam String? path, this.navigatorsRegistry,
      this.state) {
    this.path = path ?? state.currentRoute;
  }

  CompassOperator root() {
    _root = true;
    return this;
  }

  CompassOperator replace() {
    _replace = true;
    return this;
  }

  CompassOperator switchOn() {
    _switchOn = true;
    return this;
  }

  CompassOperator clear() {
    _clear = true;
    return this;
  }

  void back() {
    state.pop();
    state.update();
  }

  Future<T?> go<T>([Map<String, dynamic>? params]) async {
    _logger.info("go to path $path, replace = $_replace, use root = $_root");
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
    if (_clear) state.history.clear();

    if (_switchOn) {
      state.remove(path);
      state.push(path);
    } else if (_replace) {
      state.pop();
      state.push(path);
    } else {
      state.push(path);
    }
    if (params != null) state.historyData[path] = params;
    state.update();
    return Future<T?>.value();
  }
}
