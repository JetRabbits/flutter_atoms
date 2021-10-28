import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'navigation_screen.dart';

class InnerNavigatorRoutePage extends Page {
  final NavigationScreen screen;
  final PageStorageBucket? storageBucket;
  static final _loggerName = 'InnerNavigatorRouteCreator';
  Widget? _widget;

  @override
  Route createRoute(BuildContext context) {
    log("createRoute $name", name: _loggerName);
    print("@@@@@${_widget}");
    // if (_widget == null)
    return MaterialPageRoute(
        settings: this,
        builder: (context) {
          if (_widget == null)
            _widget = storageBucket == null
                ? screen.builder!(context)
                : PageStorage(
                bucket: storageBucket!, child: screen.builder!(context));

          return _widget!;
        });
  }

  InnerNavigatorRoutePage(
    this.screen, {
    LocalKey? key,
    this.storageBucket,
    String? name,
    Object? arguments,
    restorationId,
  }) : super(key: key, name: name, arguments: arguments, restorationId: name);
}
