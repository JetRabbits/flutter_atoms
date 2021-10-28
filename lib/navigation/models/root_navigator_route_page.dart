import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_atoms/navigation/exceptions/no_route_found.dart';
import 'package:flutter_atoms/navigation/widgets/jet_page.dart';

import 'compass_navigation_state.dart';
import 'navigation_screen.dart';


class RootNavigatorRoutePage extends Page {
  final PageStorageBucket? storageBucket;

  final String route;

  Widget? _widget;

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
          NavigationScreen screen = state.navigationModel.getScreenByRoute(route);


          if (_widget == null) {
            if (screen.group.page.path == screen.path) {
              _widget = screen.builder!(context);
              Router.of(context).backButtonDispatcher?.takePriority();
            }
            else {
              _widget = JetPage(route, state);
            }
          }


          return storageBucket == null
              ? _widget!
              : PageStorage(bucket: storageBucket!, child: _widget!);
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
