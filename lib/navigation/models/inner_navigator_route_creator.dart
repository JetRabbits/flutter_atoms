import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'navigation_screen.dart';

class InnerNavigatorRouteCreator extends Page {
  final NavigationScreen screen;
  final PageStorageBucket? storageBucket;
  static final _loggerName = 'InnerNavigatorRouteCreator';

  final String route;

  @override
  Route createRoute(BuildContext context) {
    log("createRoute $route", name: _loggerName);
    return MaterialPageRoute(
        settings: this,
        builder: (context) => storageBucket == null
            ? screen.builder!(context)
            : PageStorage(
            bucket: storageBucket!, child: screen.builder!(context)));
  }

  InnerNavigatorRouteCreator(
      this.route,
      this.screen, {
        LocalKey? key,
        this.storageBucket,
        String? name,
        Object? arguments,
        restorationId,
      }) : super(key: key, name: name, arguments: arguments, restorationId: route);
}
