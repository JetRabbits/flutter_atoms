
import 'package:flutter/material.dart';
import 'package:flutter_atoms/logging.dart';

import 'navigation_screen.dart';

class InnerNavigatorRoutePage extends Page with Loggable {
  final NavigationScreen screen;
  final PageStorageBucket? storageBucket;
  Widget? _widget;

  @override
  Route createRoute(BuildContext context) {
    logger.finest("createRoute $name");
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
