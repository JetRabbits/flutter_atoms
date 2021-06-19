import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_atoms/navigation/models/navigation_model.dart';
import 'package:injectable/injectable.dart';

@injectable
class RootNavigatorObserver extends NavigatorObserver {
  final NavigationModel navigationModel;

  RootNavigatorObserver(this.navigationModel);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {

  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {}

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {}

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    var jetPage = navigationModel.getPageByRoute(previousRoute!.settings.name!);
    // Нужно поискать другие варианты проставить backButtonDispatcher в случае, если пользователь возвращается через стрелку AppBar
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      try {
        jetPage.backButtonDispatcher!.takePriority();
      } catch (ignore) {}
    });
  }
}
