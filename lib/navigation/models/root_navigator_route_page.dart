import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_atoms/navigation/widgets/jet_page.dart';

import 'compass_navigation_state.dart';


class RootNavigatorRoutePage extends Page {
  final PageStorageBucket? storageBucket;

  final String route;

  final CompassNavigationState state;

  @override
  bool canUpdate(Page<dynamic> other) {
    return super.canUpdate(other);
  }

  @override
  Route createRoute(BuildContext context) {

    return MaterialPageRoute(
        settings: this,
        // maintainState: false,
        builder: (context) {
          var widget = JetPage(route, state);

          return storageBucket == null
              ? widget
              : PageStorage(bucket: storageBucket!, child: widget);
        });
  }

  RootNavigatorRoutePage(
    this.route,
    this.state, {
    LocalKey? key,
    this.storageBucket,
    Object? arguments,
    restorationId,
  }) : super(key: key, name: route, arguments: arguments, restorationId: route);
}
