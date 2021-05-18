import 'dart:core';
import 'dart:developer' as developer;
import 'dart:developer';

import 'package:flutter/src/material/navigation_rail.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

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
      addPath(path, routes[path],
          navButtons: navBarButtons, floatButtons: floatButtons, sideBarButtons: sideBarButtons);
    });
  }

  int _getKeyIndex(Map<String, dynamic> map, String key ) {
    var indexOf = map.keys.toList().indexOf(key);
    developer.log("$key = $indexOf", name: "NavigationModel");
    return indexOf;
  }

  void addPath(String path, WidgetBuilder? builder,
      {Map<String, BottomNavigationBarItemBuilder>? navButtons,
      Map<String, NavigationRailDestinationBuilder>? sideBarButtons,
      Map<String, FloatActionButtonConfig>? floatButtons}) {
    var uri = parseAndCheckFormat(path);
    var pagePath =
        uri.pathSegments.length > 0 ? "/${uri.pathSegments[0]}" : path;
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
            navBarButtonBuilder: navButtons != null ? navButtons[groupPath] : null,
            sideBarButtonBuilder:
                sideBarButtons != null ? sideBarButtons[groupPath] : null,
            page: page,
            navBarIndex: navButtons != null && navButtons[groupPath] != null
                ? _getKeyIndex(navButtons, groupPath)
                : -1,
            sideBarIndex:
                sideBarButtons != null
                    ? _getKeyIndex(sideBarButtons, groupPath)
                    : -1));
    group.screenMaps.putIfAbsent(
        path,
        () => NavigationScreen(
            path: path,
            builder: builder,
            group: group,
            index: group.screenMaps.length));
  }

  static Uri parseAndCheckFormat(String path) {
    var uri = Uri.file(path);
    List<String> split = uri.pathSegments;
    assert(path == "/" || (split.length > 0 && split.length < 4),
        "screen path should be uri file format like: /{page}/{group of screens}/{screen} or be /");
    return uri;
  }

  final Map<String, NavigationPage> pagesMap = <String, NavigationPage>{};

  NavigationPage getPageByPath(String path) {
    var segs = parseAndCheckFormat(path).pathSegments;
    var result = segs.length > 0 ? pagesMap["/${segs[0]}"] : pagesMap[path];
    if (result == null) throw "No page group found for $path";
    return result;
  }

  NavigationScreen getScreenByPath(String path) {
    log("getScreenByPath ${path}", name: "NavigationModel");
    var screenGroup = getScreenGroupByPath(path);
    var result = screenGroup.screenMaps[path];
    result = result ?? screenGroup.screenMaps.values.first;

    if (result == null)
      throw "No screen found for $path. Check your navigation model";
    return result;
  }

  ScreenGroup getScreenGroupByPath(String path) {
    log("getScreenGroupByPath ${path}", name: "NavigationModel");
    var split = parseAndCheckFormat(path).pathSegments;
    var page = split.length > 0 ? pagesMap["/${split[0]}"] : pagesMap[path];
    if (page == null)
      throw "No page found for $path. Check your navigation model";
    var result = split.length > 1
        ? page.screenGroupsMap["/${split[0]}/${split[1]}"]
        : page.screenGroupsMap[path];
    result = result ?? page.screenGroupsMap.values.first;

    if (result == null)
      throw "No screen group found for $path. Check your navigation model";
    return result;
  }

  clear() {
    pagesMap.clear();
  }

  @override
  Future<String> parseRouteInformation(RouteInformation routeInformation) {
    return Future.value(Uri.parse(routeInformation.location!).path);
  }

  @override
  RouteInformation restoreRouteInformation(String configuration) {
    return RouteInformation(location: configuration);
  }
}
