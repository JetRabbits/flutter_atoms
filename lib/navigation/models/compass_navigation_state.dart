
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_atoms/flutter_atoms.dart';
import 'package:flutter_atoms/logging.dart';
import 'package:injectable/injectable.dart';

// ignore: import_of_legacy_library_into_null_safe


class HistoryData<T> {
  final Completer<T> routeCompleter = Completer();
  final String path;
  T? result;
  final Map<String, dynamic> params;
  HistoryData({required this.path, this.params = const {}});
}

@lazySingleton
class CompassNavigationState extends ChangeNotifier with Loggable{

  List<String> get history => historyData.map((e) => e.path).toList();
  final List<HistoryData> historyData = [HistoryData(path: "/")];

  final NavigationModel navigationModel;

  CompassNavigationState(this.navigationModel);

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

  String get currentRoute => historyData.isNotEmpty ? historyData.last.path : "/";
  HistoryData get currentRouteData => historyData.isNotEmpty ? historyData.last: HistoryData(path: "/");

  void update() {
    logger.finest("update");
    logger.finest("hasListeners $hasListeners");
    notifyListeners();
  }
}
