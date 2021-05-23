import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import 'navigation_model.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'navigation_page.dart';
import 'navigation_screen.dart';
import 'screen_group.dart';

@singleton
class AppNavigationState extends ChangeNotifier {
  final List<String> historyRoutes = ["/"];

  // final List<Map<String, dynamic>> historyData = [];
  final NavigationModel navigationModel;

  AppNavigationState(this.navigationModel);

  NavigationScreen get currentScreen {
    return navigationModel.getScreenByRoute(historyRoutes.last);
  }

  NavigationPage get currentPage {
    return currentScreen.group.page;
  }

  ScreenGroup get currentScreenGroup {
    return currentScreen.group;
  }

  int get currentScreenGroupIndex {
    return currentScreen.group.navBarIndex;
  }

  int get currentScreenIndex {
    return currentScreen.index;
  }

  String route = "/";

  // Map<String, dynamic> routeData = <String, dynamic> {};

  void push(String route) {
    historyRoutes.add(route);
    notifyListeners();
  }

  void remove(String route) {
    historyRoutes.removeWhere((e) => e.startsWith(route));
    notifyListeners();
  }

  void removeAll() {
    historyRoutes.clear();
    notifyListeners();
  }

  void pop() {
    historyRoutes.removeLast();
    notifyListeners();
  }
}
