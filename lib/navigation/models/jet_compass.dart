import 'dart:developer' as developer;

import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'app_navigation_state.dart';
import 'navigators_register.dart';

@injectable
class JetCompass {
  static final loggerName = "JetCompass";
  final NavigatorsRegister navigatorsRegistry;
  final AppNavigationState appNavigationState;

  bool _root = false;
  bool _replace = false;
  String? path;

  JetCompass(@factoryParam this.path, this.navigatorsRegistry, this.appNavigationState);

  JetCompass root() {
    _root = true;
    return this;
  }

  JetCompass replace() {
    _replace = true;
    return this;
  }

  Future<T?> go<T>([Map<String, String>? params]) async {
    developer.log("go to path $path, replace = $_replace, use root = $_root", name: loggerName);
    var rootNavigator = navigatorsRegistry.getRoot().currentState;
    if (rootNavigator == null) return Future.value(null);
    var _currentPagePath = appNavigationState.currentPage.path;
    developer.log("currentPagePath $_currentPagePath", name: loggerName);
    var _nextPagePath = appNavigationState.navigationModel.getPageByPath(path!).path;
    developer.log("nextPagePath $_nextPagePath", name: loggerName);
    NavigatorState? _operationNavigator;
    if (_currentPagePath == _nextPagePath) {
      developer.log("_currentPagePath == _nextPagePath", name: loggerName);
      _operationNavigator = navigatorsRegistry.get(_currentPagePath!).currentState;
    } else {
      developer.log("using root navigator", name: loggerName);
      _operationNavigator = rootNavigator;
    }
    if (_replace)
      return _operationNavigator?.pushReplacementNamed(path!) as Future<T?>;
    else
      return _operationNavigator?.pushNamed(path!) as Future<T?>;
  }
}