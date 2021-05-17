import 'dart:developer' as developer;
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

@singleton
class NavigatorsRegister {
  static final _loggerName = "NavigatorsRegister";
  final Map<String, GlobalKey<NavigatorState>> _navigatorsMap = {};

  String _unify(String path) {
    var segments = Uri.parse(path).pathSegments;
    var result = segments.isEmpty ? "/" : segments.first;
    return result;
  }

  GlobalKey<NavigatorState> register(String path, GlobalKey<NavigatorState> key) {
    log("registering navigator key for path $path", name: _loggerName);
    log("registered navigators in the map: $_navigatorsMap", name: _loggerName);
    if (_navigatorsMap[_unify(path)] != null) {
      log("navigator already registered. Rewriting map", name: _loggerName);
    }
    _navigatorsMap[_unify(path)] = key;
    return key;
  }

  GlobalKey<NavigatorState> get(String path) {
    developer.log("get navigator for path $path", name: _loggerName);
    var navigator = _navigatorsMap[_unify(path)];
    assert(navigator != null, "Navigator should be registered for $path. Please check navigation model in JetApp. Action to do is to set for $path some screen widget");
    return navigator!;
  }

  GlobalKey<NavigatorState> getRoot() {
    developer.log("get root navigator", name: _loggerName);
    var navigator = _navigatorsMap[_unify("/")];
    assert(navigator != null, "Root Navigator should be registered. Please check navigation model in JetApp.");
    return navigator!;
  }

  void remove(String path) => _navigatorsMap.remove(_unify(path));
}
