import 'dart:developer' as developer;

import 'package:flutter/widgets.dart';

class KeyRegister {
  static final _instance = KeyRegister._internal();
  final Map<String, GlobalKey<NavigatorState>> _navigatorsMap = {};

  String unify(String path) {
    var segments = Uri.parse(path).pathSegments;
    var result = segments.isEmpty ? "/" : segments.first;
    developer.log("unify $path to $result", name: "KeyRegister");
    return result;
  }

  GlobalKey<NavigatorState> register(String path, GlobalKey<NavigatorState> key) {
    developer.log("register key for $path", name: "KeyRegister");
    developer.log("registered keys ${_navigatorsMap.length}", name: "KeyRegister");
    _navigatorsMap[unify(path)] = key;
    return key;
  }

  GlobalKey<NavigatorState> get(String path) {
    developer.log("get key for $path", name: "KeyRegister");
    developer.log("registered keys ${_navigatorsMap.length}", name: "KeyRegister");

    return _navigatorsMap[unify(path)]!;
  }

  GlobalKey<NavigatorState> getRoot() {
    developer.log("get root key", name: "KeyRegister");
    developer.log("registered keys ${_navigatorsMap.length}", name: "KeyRegister");
    return _navigatorsMap[unify("/")]!;
  }

  void remove(String path) => _navigatorsMap.remove(unify(path));

  KeyRegister._internal();

  static KeyRegister get instance => _instance;
}
