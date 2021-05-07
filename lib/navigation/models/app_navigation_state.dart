import 'package:flutter/material.dart';

import 'navigation_model.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'navigation_page.dart';
import 'navigation_screen.dart';
import 'screen_group.dart';

class AppNavigationState extends ChangeNotifier {
  static final _instance = AppNavigationState._internal();
  final List<String> historyRoutes = ["/"];
  // final List<Map<String, dynamic>> historyData = [];
  late final NavigationModel navigationModel;

  factory AppNavigationState(){
    return _instance;
  }

  factory AppNavigationState.init(NavigationModel navigationModel){
    _instance.navigationModel = navigationModel;
    return _instance;
  }

  NavigationScreen get currentScreen {
    return navigationModel.getScreenByPath(historyRoutes.last);
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

  void push(String route){
    historyRoutes.add(route);
    notifyListeners();
  }

  void remove(String route){
    historyRoutes.removeWhere((e) => e.startsWith(route));
    notifyListeners();
  }

  void removeAll(){
    historyRoutes.clear();
    notifyListeners();
  }

  void pop(){
    historyRoutes.removeLast();
    notifyListeners();
  }

  AppNavigationState._internal();


}
