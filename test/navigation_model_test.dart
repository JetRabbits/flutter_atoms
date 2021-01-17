import 'package:catcher/catcher.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_atoms/flutter_atoms.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockContext extends Mock implements BuildContext {}

class MockFirebaseCrashlytics extends Mock implements FirebaseCrashlytics {}

class MockFirebaseAnalytics extends Mock implements FirebaseAnalytics {}

class MockReportModeAction extends Mock implements ReportModeAction {}

Future<void> main() async {
  setUp(() {
  });

  test('Navigation Model parsing tests', () async {
    var navigationModel = NavigationModel(routes: {
      "/main/lookup/search": (context) => Text("SearchScreen"),
      "/main/lookup/catalog": (context) => Text("CatalogScreen"),
      "/main/profile": (context) => Text("ProfileScreen"),
      "/details": (context) => Text("DetailsScreen"),
    }, buttons: {
      "/main/lookup": (context) => BottomNavigationBarItem(icon: Icon(Icons.search)),
      "/main/profile": (context) => BottomNavigationBarItem(icon: Icon(Icons.person)),
    });
    var page = navigationModel.getPageByPath("/main/lookup/search");
    expect(page.path, "/main");
    var group = navigationModel.getScreenGroupByPath("/main/lookup/catalog");
    expect(group.path, "/main/lookup");
    expect(group.buttonBuilder, isNotNull);

    var screen = navigationModel.getScreenByPath("/main/lookup/catalog");
    expect(screen.path, "/main/lookup/catalog");

    group = navigationModel.getScreenGroupByPath("/main/profile");
    expect(group.path, "/main/profile");
    expect(group.buttonBuilder, isNotNull);

    group = navigationModel.getScreenGroupByPath("/details");
    expect(group.path, "/details");
    expect(group.buttonBuilder, isNull);

    page = navigationModel.getPageByPath("/details");
    expect(page.path, "/details");

    screen = navigationModel.getScreenByPath("/details");
    expect(screen.path, "/details");
  });
}