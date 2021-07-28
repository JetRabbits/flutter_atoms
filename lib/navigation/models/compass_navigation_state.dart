import 'dart:developer';

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

get compass => GetIt.I<CompassNavigationState>();

@singleton
class CompassNavigationState extends ChangeNotifier {
  static final _logger = Logger('AppNavigationState');

  CompassOperator to(String path) => GetIt.I<CompassOperator>(param1: path);

  Map<String, dynamic> get data => historyData[currentRoute]!;

  final List<String> history = ["/"];
  final Map<String, Map<String, dynamic>> historyData = {"/": {}};

  final NavigationModel navigationModel;

  final RouteInformationProvider routeInformationProvider =
      PlatformRouteInformationProvider(
          initialRouteInformation: RouteInformation(location: "/"));

  dynamic lastPopResult;

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

  String get currentRoute => history.last;

  void push(String route) {
    try {
      var validatedRoute = navigationModel.routesValidator.validate(route);
      navigationModel.getScreenByRoute(validatedRoute);
      history.add(validatedRoute);
      historyData[validatedRoute] =
          navigationModel.getParametersFromRoute(route).cast();
    } catch (e) {
      history.add('/404');
    }
  }

  void pop() {
    history.removeLast();
  }

  void remove(String path) {
    history.remove(path);
  }

  void clear() {
    history.clear();
    push("/");
  }

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
