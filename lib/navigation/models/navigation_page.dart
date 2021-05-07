import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'float_action_button_config.dart';
import 'screen_group.dart';

class NavigationPage {
  String? path;
  NavigationPage({this.path, this.floatActionButtonConfig});

  Map<String, ScreenGroup> screenGroupsMap = <String, ScreenGroup>{};

  BackButtonDispatcher? backButtonDispatcher;

  final FloatActionButtonConfig? floatActionButtonConfig;

  void addGroup(ScreenGroup group) {
    if (path == null) _updatePathByScreenGroup(group);
    _checkPath(group);
    screenGroupsMap.putIfAbsent(group.path, () => group);
  }

  String _updatePathByScreenGroup(ScreenGroup group) {
    var firstScreenGroupUri = Uri.file(group.path);
    var segList = firstScreenGroupUri.pathSegments.toList();
    if (segList.length > 0) segList = [segList[0]];
    return Uri(scheme: firstScreenGroupUri.scheme, pathSegments: segList).path;
  }

  void _checkPath(ScreenGroup group) {
    assert(path != null, "page path is null");
    if (!group.path.startsWith(path!)) throw "Group path: ${group
        .path} does not match page path $path. Please check configuration";
  }
}