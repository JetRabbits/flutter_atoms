import 'package:flutter/material.dart';
import 'models.dart';

class AppNavigationState extends ChangeNotifier {
  final List<String> historyRoutes = ["/"];
  // final List<Map<String, dynamic>> historyData = [];
  final NavigationModel navigationModel;

  AppNavigationState(this.navigationModel);

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
    return currentScreen.group.index;
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


}