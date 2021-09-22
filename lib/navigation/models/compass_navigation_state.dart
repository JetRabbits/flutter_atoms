
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_atoms/flutter_atoms.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import 'navigation_model.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'navigation_page.dart';
import 'navigation_screen.dart';
import 'screen_group.dart';


class HistoryData<T> {
  final Completer<T> routeCompleter = Completer();
  final String path;
  T? result;
  final Map<String, dynamic> params;
  HistoryData({required this.path, this.params = const {}});
}

@singleton
class CompassNavigationState extends ChangeNotifier {
  static final _logger = Logger('CompassNavigationState');

  List<String> get history => historyData.map((e) => e.path).toList();
  final List<HistoryData> historyData = [HistoryData(path: "/")];

  final NavigationModel navigationModel;

  final RouteInformationProvider routeInformationProvider =
      PlatformRouteInformationProvider(
          initialRouteInformation: RouteInformation(location: "/"));

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

  String get currentRoute => historyData.last.path;
  HistoryData get currentRouteData => historyData.last;


  void _notifyListeners() {
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      notifyListeners();
    });
  }

  void update() {
    _logger.info("update");
    _logger.info("hasListeners $hasListeners");
    notifyListeners();
  }
}
