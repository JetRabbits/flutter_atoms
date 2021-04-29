import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_atoms/flutter_atoms.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockContext extends Mock implements BuildContext {}

Future<void> main() async {
  setUp(() {
  });

  test('Navigation Model parsing tests', () async {
    var navigationModel = NavigationModel(routes: {
      "/main/lookup/search": (context) => Text("SearchScreen"),
      "/main/lookup/catalog": (context) => Text("CatalogScreen"),
      "/main/profile": (context) => Text("ProfileScreen"),
      "/details": (context) => Text("DetailsScreen"),
    }, navBarButtons: {
      "/main/lookup": (context) => BottomNavigationBarItem(icon: Icon(Icons.search)),
      "/main/profile": (context) => BottomNavigationBarItem(icon: Icon(Icons.person)),
    });
    var page = navigationModel.getPageByPath("/main/lookup/search");
    expect(page.path, "/main");
    var group = navigationModel.getScreenGroupByPath("/main/lookup/catalog");
    expect(group.path, "/main/lookup");
    expect(group.navBarButtonBuilder, isNotNull);

    var screen = navigationModel.getScreenByPath("/main/lookup/catalog");
    expect(screen.path, "/main/lookup/catalog");

    group = navigationModel.getScreenGroupByPath("/main/profile");
    expect(group.path, "/main/profile");
    expect(group.navBarButtonBuilder, isNotNull);

    group = navigationModel.getScreenGroupByPath("/details");
    expect(group.path, "/details");
    expect(group.navBarButtonBuilder, isNull);

    page = navigationModel.getPageByPath("/details");
    expect(page.path, "/details");

    screen = navigationModel.getScreenByPath("/details");
    expect(screen.path, "/details");
  });
}
