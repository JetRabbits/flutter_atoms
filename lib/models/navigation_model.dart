import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter_atoms/models/navigation_page.dart';

import 'models.dart';
import 'navigation_screen.dart';

typedef BottomNavigationBarItemBuilder = BottomNavigationBarItem Function(BuildContext context);
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

  NavigationModel({@required Map<String, WidgetBuilder> routes, Map<String, BottomNavigationBarItemBuilder> buttons}) {
    routes.keys.forEach((path) {
      addPath(path, routes[path], buttons: buttons);
    });
  }

  void addPath(String path, WidgetBuilder builder, {Map<String, BottomNavigationBarItemBuilder> buttons}){
    var uri = parseAndCheckFormat(path);
    var pagePath = uri.pathSegments.length > 0 ? "/${uri.pathSegments[0]}" : path;
    var page = pagesMap.putIfAbsent(pagePath, () => NavigationPage(path: pagePath));
    var groupPath = pagePath + (uri.pathSegments.length > 1 ? "/" + uri.pathSegments[1] : "");
    var group = page.screenGroupsMap.putIfAbsent(groupPath,
            () => ScreenGroup(path: groupPath, buttonBuilder: buttons != null ? buttons[groupPath] : null, page: page,
                index: buttons != null && buttons[groupPath] != null ? page.screenGroupsMap.length: -1));
    group.screenMaps.putIfAbsent(path, () => NavigationScreen(path: path, builder: builder, group: group, index: group.screenMaps.length));
  }

  static Uri parseAndCheckFormat(String path) {
    assert(path != null, "path should not be null");
    var uri = Uri.file(path);
    List<String> split = uri.pathSegments;
    assert(path == "/" || (split.length > 0 && split.length < 4),
        "screen path should be uri file format like: /{page}/{group of screens}/{screen} or be /");
    return uri;
  }

  final Map<String, NavigationPage> pagesMap = <String, NavigationPage>{};

  NavigationPage getPageByPath(String path) {
    var segs = parseAndCheckFormat(path).pathSegments;
    return segs.length > 0 ? pagesMap["/${segs[0]}"]: pagesMap[path];
  }

  NavigationScreen getScreenByPath(String path) {
    return getScreenGroupByPath(path)?.screenMaps[path];
  }

  ScreenGroup getScreenGroupByPath(String path) {
    var split = parseAndCheckFormat(path).pathSegments;
    var page = split.length > 0 ? pagesMap["/${split[0]}"] : pagesMap[path];
    if (page == null) throw "No page found for ${path} check your navigation model";
    var result = split.length > 1 ? page?.screenGroupsMap["/${split[0]}/${split[1]}"] : page?.screenGroupsMap[path];
    if (result == null) throw "No screen group found for ${path}";
    return result;
  }

  clear() {
    pagesMap.clear();
  }

  @override
  Future<String> parseRouteInformation(RouteInformation routeInformation) {
    print("!!!!!!!");
    return Future.value(Uri.parse(routeInformation.location).path);
  }

  @override
  RouteInformation restoreRouteInformation(String configuration) {
    print("!!!!!!!");
    return RouteInformation(location: configuration);
  }
}
