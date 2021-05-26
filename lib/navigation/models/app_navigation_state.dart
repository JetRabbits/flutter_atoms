import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:injectable/injectable.dart';

import 'navigation_model.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'navigation_page.dart';
import 'navigation_screen.dart';
import 'screen_group.dart';

@singleton
class AppNavigationState extends ChangeNotifier {
  static final _loggerName = 'AppNavigationState';

  // final List<Map<String, dynamic>> historyData = [];
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

  String currentRoute = "/";

  // Map<String, dynamic> routeData = <String, dynamic> {};


  void _notifyListeners() {
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) { notifyListeners(); });
  }
}
