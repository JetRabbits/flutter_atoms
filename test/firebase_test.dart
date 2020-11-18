import 'package:catcher/catcher.dart';
import 'package:catcher/model/platform_type.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_atoms/flutter_atoms.dart';
import 'package:flutter_atoms/integrations/analytics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockContext extends Mock implements BuildContext {}

class MockFirebaseCrashlytics extends Mock implements FirebaseCrashlytics {}

class MockFirebaseAnalytics extends Mock implements FirebaseAnalytics {}

class MockReportModeAction extends Mock implements ReportModeAction {}

Future<void> main() async {
  BuildContext context;
  TestWidgetsFlutterBinding.ensureInitialized();
  FirebaseAnalytics firebaseAnalytics;
  FirebaseCrashlytics firebaseCrashlytics;
  MockReportModeAction mockReportModeAction;
  setUp(() {
    firebaseAnalytics = MockFirebaseAnalytics();
    firebaseCrashlytics = MockFirebaseCrashlytics();
    mockReportModeAction = MockReportModeAction();
    context = MockContext();
    when(firebaseCrashlytics.recordError(any, any, reason: anyNamed("reason")))
        .thenAnswer((realInvocation) async {
      print("firebase: ${realInvocation.positionalArguments.first}");
    });
    // when(firebaseCrashlytics.setUserIdentifier(any)).thenAnswer((_) async => print(_.positionalArguments.first));

    when(firebaseAnalytics.logEvent(
            name: anyNamed("name"), parameters: anyNamed("parameters")))
        .thenAnswer((realInvocation) async => print(
            "analytics: ${realInvocation.namedArguments[Symbol('name')]}"));
    // when(firebaseAnalytics.setUserId(any)).thenAnswer((_) async => print(_.positionalArguments.first));
  });

  test('Firebase Analytics integration with Catcher', () async {
    await Analytics().configure(
        crashlytics: firebaseCrashlytics,
        analytics: firebaseAnalytics,
        options: AnalyticsOptions(onUserId: (context) async => "guest"));
    var reportMode = AnalyticsCatcherReportMode();
    reportMode.setReportModeAction(mockReportModeAction);
    var report = Report(
        Exception("Test Error"),
        StackTrace.current,
        DateTime.now(),
        <String, dynamic>{},
        <String, dynamic>{},
        <String, dynamic>{},
        FlutterErrorDetails(),
        PlatformType.Android);
    reportMode.requestAction(report, context);
    await Future.delayed(Duration(milliseconds: 100));
    verify(firebaseCrashlytics.setCrashlyticsCollectionEnabled(true)).called(1);
    expect(verify(firebaseCrashlytics.setUserIdentifier(captureAny)).captured,
        ["guest"]);
    expect(verify(firebaseAnalytics.setUserId(captureAny)).captured, ["guest"]);
  });
}
