import 'package:flutter/widgets.dart';
import 'package:flutter_atoms/logging.dart';
import 'package:flutter_atoms/navigation.dart';
import 'package:injectable/injectable.dart';

@injectable
class InnerNavigatorObserver extends NavigatorObserver with Loggable {
  NavBarCubit? navbarCubit;

  InnerNavigatorObserver(@factoryParam this.navbarCubit);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    logger.finest("didPush");
    _update(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    logger.finest("didReplace");
    _update(newRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    logger.finest("didPop");
    _update(previousRoute);
  }

  void _update(Route<dynamic>? route) {
    if (route != null) navbarCubit!.updatePath(route.settings.name);
  }
}