import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_atoms/navigation/models/navigators_register.dart';
import 'package:injectable/injectable.dart';

import '../navigation.dart';

@injectable
class InnerRouterDelegate extends RouterDelegate<String>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<String> {
  final AppNavigationState state;

  final String? pageRoute;

  late final InnerNavigatorObserver _innerNavigatorObserver;

  final NavBarCubit? navBarCubit;

  final PageStorageBucket _bucket = PageStorageBucket();

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  final NavigatorsRegister navigatorsRegister;

  InnerRouterDelegate(@factoryParam this.pageRoute, @factoryParam this.navBarCubit, this.state, this.navigatorsRegister) {
    developer.log("Creating with pageRoute = $pageRoute",
        name: "InnerRouterDelegate");
    _innerNavigatorObserver = InnerNavigatorObserver(navBarCubit!);
    navigatorsRegister.register(this.pageRoute!, _navigatorKey);
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      observers: [_innerNavigatorObserver],
      //only our pages mapped by pageRoute
      pages: state.historyRoutes.where((path) => path.startsWith(RegExp('$pageRoute.*'))).map<Page>((path) {
        var screen = state.navigationModel.getScreenByRoute(path);
        return JetNavPage(screen, _bucket, name: screen.path);
      }).toList(),
       onGenerateInitialRoutes: (navigatorState, initialRoute) =>
       [
         buildRoute(context, initialRoute,
             state.navigationModel
                 .getScreenByRoute(initialRoute)
                 .builder)
       ],
      onGenerateRoute: (settings) {
        Router.of(context).backButtonDispatcher!.takePriority();
        var screen = state.navigationModel.getScreenByRoute(settings.name!);
        state.push(screen.path);
        notifyListeners();
        return buildRoute(context, screen.path, screen.builder,
            settings: settings);
      },
      onPopPage: (Route<dynamic> route, dynamic result) {
        developer.log("onPopPage call ${route.settings.name}",
            name: "InnerRouterDelegate");
        if (!route.didPop(result)) {
          return false;
        }
        state.pop();
        notifyListeners();
        return true;
      },
    );
  }

  @override
  String get currentConfiguration {
    developer.log("currentConfiguration call ${state.currentScreen.path}",
        name: "InnerRouterDelegate");
    return state.currentScreen.path;
  }

  @override
  Future<void> setNewRoutePath(String path) async {
    developer.log("setNewRoutePath $path", name: "InnerRouterDelegate");
    state.push(path);
    notifyListeners();
  }

  PageRoute buildRoute(
          BuildContext context, String route, WidgetBuilder? screenBuilder,
          {RouteSettings? settings}) =>
      MaterialPageRoute(
          settings: settings ?? RouteSettings(name: route),
          builder: (context) =>
              PageStorage(bucket: _bucket, child: screenBuilder!(context)));

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;
}
