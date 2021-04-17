import 'package:flutter/widgets.dart';

import 'navigation_page.dart';
import 'navigation_screen.dart';

class ScreenGroup {
  final String path;

  final NavigationPage page;

  final int index;

  ScreenGroup({required this.path, required this.page, required this.index, this.navBarButtonBuilder});

  BottomNavigationBarItem Function(BuildContext context)? navBarButtonBuilder;
  Map<String, NavigationScreen> screenMaps = <String, NavigationScreen>{};

  void addScreen(NavigationScreen screen) {
    _updatePath(screen);
    _checkPath(screen);
    screenMaps.putIfAbsent(screen.path, () => screen);
  }

  String _updatePath(NavigationScreen screen) {
    var screenUri = Uri.file(screen.path);
    var segList = screenUri.pathSegments.toList();
    if (segList.length > 1) segList = [segList[0], segList[1] ];
    return Uri(scheme: screenUri.scheme, pathSegments: segList).path;
  }

  void _checkPath(NavigationScreen screen) {
    if (!screen.path.startsWith(path)) throw
        "Screen path:"
        " ${screen.path} does not match screen group path "
        "$path. Please check configuration";
    if (screenMaps[screen.path] != null) throw "Screen ${screen.path} already added. Please check configuration";
  }


}
