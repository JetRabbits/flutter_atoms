import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_atoms/navigation/widgets/jet_page.dart';

import 'app_navigation_state.dart';

class RootNavigatorRouteCreator extends Page {
  final PageStorageBucket? storageBucket;

  final String route;

  final AppNavigationState state;

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
        settings: this,
        builder: (context) {
          var widget = JetPage(route, state);

          return storageBucket == null
              ? widget
              : PageStorage(bucket: storageBucket!, child: widget);
        });
  }

  RootNavigatorRouteCreator(
      this.route,
      this.state, {
        LocalKey? key,
        this.storageBucket,
        Object? arguments,
        restorationId,
      }) : super(key: key, name: route, arguments: arguments, restorationId: route);
}
