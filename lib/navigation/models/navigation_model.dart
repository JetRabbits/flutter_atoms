import 'dart:core';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_atoms/logging.dart';
import 'package:logging/logging.dart';
import '../exceptions/no_route_found.dart';


import 'button_config.dart';
import 'float_action_button_config.dart';
import 'navigation_page.dart';
import 'navigation_screen.dart';
import 'screen_group.dart';

typedef BottomNavigationBarItemBuilder = BottomNavigationBarItem Function(
    BuildContext context);
typedef NavigationRailDestinationBuilder = NavigationRailDestination Function(
    BuildContext context);

typedef ButtonBuilder = ButtonConfig Function(BuildContext context);

///
/// Navigation model take routes as pattern /page/group/screen
/// For example if you have main route with 3 bottom navigation buttons then your routes should be:
/// /main/group1/first_screen
/// /main/group1/second_screen
/// /main/group1/third_screen
///
class NavigationModel extends RouteInformationParser<String> with Loggable {
  Widget? sideBarLogo;
  String Function(BuildContext, String)? onTitleText;
  Color Function(BuildContext, String)? onTitleColor;

  RoutesValidator routesValidator;

  NavigationModel({
    required Map<String, WidgetBuilder> routes,
    Map<String, BottomNavigationBarItemBuilder>? navBarButtons,
    Map<String, NavigationRailDestinationBuilder>? sideBarButtons,
    this.sideBarLogo,
    this.onTitleColor,
    this.onTitleText,
    Map<String, FloatActionButtonConfig>? floatButtons,
    required this.routesValidator,
  }) {
    routes.keys.forEach((path) {
      addRoutePattern(path, routes[path],
          navButtons: navBarButtons,
          floatButtons: floatButtons,
          sideBarButtons: sideBarButtons);
    });
  }

  Map<String, String> getParametersFromRoute(String route) {
    var screenByRoute = getScreenByRoute(route);
    Map<String, String> result = {};
    var pattern =
        screenByRoute.path.replaceAllMapped(RegExp(r':(\w+)'), (match) {
      return '(?<${match.group(1)!}>\\w+)?';
    });
    logger.finest('getParametersFromRoute pattern: $pattern');

    RegExp(pattern)
        .allMatches(route)
        .forEach((match) => match.groupNames.forEach((value) {
              if (match.namedGroup(value) != null) {
                result.putIfAbsent(value, () => match.namedGroup(value)!);
              }
            }));
    logger.finest('getParametersFromRoute: $result');
    return result;
  }

  int _getKeyIndex(Map<String, dynamic> map, String key) {
    var indexOf = map.keys.toList().indexOf(key);
    logger.finest("$key = $indexOf");
    return indexOf;
  }

  void addRoutePattern(String pattern, WidgetBuilder? builder,
      {Map<String, BottomNavigationBarItemBuilder>? navButtons,
      Map<String, NavigationRailDestinationBuilder>? sideBarButtons,
      Map<String, FloatActionButtonConfig>? floatButtons}) {
    var uri = parseAndCheckFormat(pattern);
    var pagePath =
        uri.pathSegments.length > 0 ? "/${uri.pathSegments[0]}" : pattern;
    var page = pagesMap.putIfAbsent(
        pagePath,
        () => NavigationPage(
            path: pagePath,
            floatActionButtonConfig:
                floatButtons != null ? floatButtons[pagePath] : null));
    var groupPath = pagePath +
        (uri.pathSegments.length > 1 ? "/" + uri.pathSegments[1] : "");
    var group = page.screenGroupsMap.putIfAbsent(
        groupPath,
        () => ScreenGroup(
            path: groupPath,
            navBarButtonBuilder:
                navButtons != null ? navButtons[groupPath] : null,
            sideBarButtonBuilder:
                sideBarButtons != null ? sideBarButtons[groupPath] : null,
            page: page,
            navBarIndex: navButtons != null && navButtons[groupPath] != null
                ? _getKeyIndex(navButtons, groupPath)
                : -1,
            sideBarIndex: sideBarButtons != null
                ? _getKeyIndex(sideBarButtons, groupPath)
                : -1));
    group.screenMaps.putIfAbsent(
        pattern,
        () => NavigationScreen(
            path: pattern,
            builder: builder,
            group: group,
            index: group.screenMaps.length));
  }

  static Uri parseAndCheckFormat(String route) {
    var uri = Uri.parse(route);
    List<String> split = uri.pathSegments;
    assert(route == "/" || (split.length > 0 && split.length < 5),
        "screen path should be uri file format like: /{page}/{group of screens}/{screen}/:paramId?param2=value or be /");
    return uri;
  }

  final Map<String, NavigationPage> pagesMap = <String, NavigationPage>{};

  NavigationPage getPageByRoute(String route) {
    var segs = parseAndCheckFormat(route).pathSegments;
    var result = segs.length > 0 ? pagesMap["/${segs[0]}"] : pagesMap[route];
    if (result == null)
      throw NoRouteFoundException(route);
    return result;
  }

  NavigationScreen getScreenByRoute(String route) {
    logger.finest("getScreenByRoute $route");
    var screenGroup = getScreenGroupByRoute(route);
    var split = parseAndCheckFormat(route).pathSegments;
    var path =
        split.length > 2 ? "/${split[0]}/${split[1]}/${split[2]}" : route;
    var result = screenGroup.screenMaps[path];
    result = result ?? screenGroup.screenMaps.values.first;

    if (result == null)
      throw NoRouteFoundException(route);
    return result;
  }

  ScreenGroup getScreenGroupByRoute(String route) {
    logger.finest("getScreenGroupByRoute $route");
    var split = parseAndCheckFormat(route).pathSegments;
    var page = split.length > 0 ? pagesMap["/${split[0]}"] : pagesMap[route];
    if (page == null)
      throw NoRouteFoundException(route);
    var result = split.length > 1
        ? page.screenGroupsMap["/${split[0]}/${split[1]}"]
        : page.screenGroupsMap[route];
    result = result ?? page.screenGroupsMap.values.first;

    if (result == null)
      throw NoRouteFoundException(route);
    return result;
  }

  clear() {
    pagesMap.clear();
  }

  @override
  Future<String> parseRouteInformation(RouteInformation routeInformation) {
    logger.finest("parseRouteInformation $routeInformation");
    return Future<String>.value(Uri.parse(routeInformation.location!).path);
  }

  @override
  RouteInformation restoreRouteInformation(String configuration) {
    return RouteInformation(location: configuration);
  }
}

class RoutesValidator {
  final String Function(String) onValidate;

  RoutesValidator({required this.onValidate});

  String validate(String route) {
    return onValidate(route);
  }
}
