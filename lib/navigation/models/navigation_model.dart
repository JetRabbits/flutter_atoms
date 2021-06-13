import 'dart:core';
import 'dart:developer';

import 'package:flutter/src/material/navigation_rail.dart';
import 'package:flutter/widgets.dart';

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
/// Navigation model take routes as pattern /Flutter_Navigator_Route/Internal_of_Route_Screen_Name
/// For example if you have main route with 3 bottom navigation buttons then your routes should be:
/// /main/first_screen
/// /main/second_screen
/// /main/third_screen
/// After that you can ask NavigatorCubit.navigateTo('/main/second_screen')
/// For example if you have main route with 3 bottom navigation buttons and on the second screen (second button) there are 2 screens then your routes should be:
/// /main/first_screen
/// /main/second_screen
/// /main/second_screen/sub_screen_1
/// /main/second_screen/sub_screen_2
/// /main/third_screen
/// After that you can ask NavigatorCubit.navigateTo('/main/second_screen/sub_screen_1')
///
class NavigationModel extends RouteInformationParser<String> {
  Widget? sideBarLogo;

  NavigationModel({
    required Map<String, WidgetBuilder> routes,
    Map<String, BottomNavigationBarItemBuilder>? navBarButtons,
    Map<String, NavigationRailDestinationBuilder>? sideBarButtons,
    this.sideBarLogo,
    Map<String, FloatActionButtonConfig>? floatButtons,
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
    var pattern = screenByRoute.path
        .replaceAllMapped(RegExp(r':(\w+)'), (match) {
      return '(?<${match.group(1)!}>\\w+)?';
    });
    log('getParametersFromRoute pattern: $pattern', name: 'NavigationModel');

    RegExp(pattern).allMatches(route).forEach((match) =>
        match.groupNames.forEach((value) {
          if (match.namedGroup(value) != null){
            result.putIfAbsent(value, () => match.namedGroup(value)!);
          }
        }));
    log('getParametersFromRoute: $result', name: 'NavigationModel');
    return result;
  }

  int _getKeyIndex(Map<String, dynamic> map, String key) {
    var indexOf = map.keys.toList().indexOf(key);
    log("$key = $indexOf", name: "NavigationModel");
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
    if (result == null) throw "No page group found for $route";
    return result;
  }

  NavigationScreen getScreenByRoute(String route) {
    log("getScreenByRoute ${route}", name: "NavigationModel");
    var screenGroup = getScreenGroupByRoute(route);
    var split = parseAndCheckFormat(route).pathSegments;
    var path = split.length > 1
        ? "/${split[0]}/${split[1]}/${split[2]}"
        : route;
    var result = screenGroup.screenMaps[path];
    result = result ?? screenGroup.screenMaps.values.first;

    if (result == null)
      throw "No screen found for $route. Check your navigation model";
    return result;
  }

  ScreenGroup getScreenGroupByRoute(String route) {
    log("getScreenGroupByRoute ${route}", name: "NavigationModel");
    var split = parseAndCheckFormat(route).pathSegments;
    var page = split.length > 0 ? pagesMap["/${split[0]}"] : pagesMap[route];
    if (page == null)
      throw "No page found for $route. Check your navigation model";
    var result = split.length > 1
        ? page.screenGroupsMap["/${split[0]}/${split[1]}"]
        : page.screenGroupsMap[route];
    result = result ?? page.screenGroupsMap.values.first;

    if (result == null)
      throw "No screen group found for $route. Check your navigation model";
    return result;
  }

  clear() {
    pagesMap.clear();
  }

  @override
  Future<String> parseRouteInformation(RouteInformation routeInformation) {
    return Future<String>.value(Uri.parse(routeInformation.location!).path);
  }

  @override
  RouteInformation restoreRouteInformation(String configuration) {
    return RouteInformation(location: configuration);
  }
}