import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'navigation_model.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'navigation_page.dart';
import 'navigation_screen.dart';
import 'screen_group.dart';

final tracker = GetIt.I<AppNavigationState>();

@singleton
class AppNavigationState extends ChangeNotifier {
  static final _loggerName = 'AppNavigationState';
  Map<String, dynamic> get data => historyData[currentRoute]!;

  final List<String> history = ["/"];
  final Map<String, Map<String, dynamic>> historyData = {"/": {}};

  final NavigationModel navigationModel;

  dynamic lastPopResult;

  AppNavigationState(this.navigationModel);

  NavigationScreen get currentScreen {
    return navigationModel.getScreenByRoute(currentRoute);
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

  String get currentRoute => history.last;


  void push(String route){
    try {
      navigationModel.getScreenByRoute(route);
      history.add(route);
      historyData[route] = navigationModel.getParametersFromRoute(route).cast();
    } catch (e) {
      history.add('/404');
    }
  }

  void pop(){
    history.removeLast();
  }

  void clear(){
    history.clear();
    push("/");
  }


  void _notifyListeners() {
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) { notifyListeners(); });
  }

  void update() {
    log("update", name: _loggerName);
    log("hasListeners $hasListeners", name: _loggerName);
    notifyListeners();
  }
}
