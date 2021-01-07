import 'package:flutter/widgets.dart';

class PageNavigatorObserver extends NavigatorObserver {
  PageNavigatorObserver();

  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {}

  @override
  void didReplace({Route<dynamic> newRoute, Route<dynamic> oldRoute}) {}

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {}
}