import 'package:flutter/widgets.dart';
import 'package:flutter_atoms/logging.dart';
import 'package:injectable/injectable.dart';

@singleton
class NavigatorsRegister with Loggable{
  final Map<String, GlobalKey<NavigatorState>> _navigatorsMap = {};

  String _unify(String path) {
    var segments = Uri.parse(path).pathSegments;
    var result = segments.isEmpty ? "/" : segments.first;
    return result;
  }

  GlobalKey<NavigatorState> register(
      String path, GlobalKey<NavigatorState> key) {
    logger.finest("registering navigator key for path $path");
    logger.finest("registered navigators in the map: $_navigatorsMap");
    if (_navigatorsMap[_unify(path)] != null) {
      logger.finest("navigator already registered. Rewriting map");
    }
    _navigatorsMap[_unify(path)] = key;
    return key;
  }

  GlobalKey<NavigatorState> get(String path) {
    logger.finest("get navigator for path $path");
    var navigator = _navigatorsMap[_unify(path)];
    assert(navigator != null,
        "Navigator should be registered for $path. Please check navigation model in JetApp. Action to do is to set for $path some screen widget");
    return navigator!;
  }

  GlobalKey<NavigatorState> getRoot() {
    logger.finest("get root navigator");
    var navigator = _navigatorsMap[_unify("/")];
    assert(navigator != null,
        "Root Navigator should be registered. Please check navigation model in JetApp.");
    return navigator!;
  }

  void remove(String path) => _navigatorsMap.remove(_unify(path));
}
