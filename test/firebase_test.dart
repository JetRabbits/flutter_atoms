// @dart=2.9
import 'package:catcher/catcher.dart';
import 'package:catcher/model/platform_type.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_atoms/flutter_atoms.dart';
import 'package:flutter_atoms/integrations/analytics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBuildContext extends Mock implements BuildContext {}

class MockFirebaseCrashlytics extends Mock implements FirebaseCrashlytics {}

class MockFirebaseAnalytics extends Mock implements FirebaseAnalytics {}

class MockReportModeAction extends Mock implements ReportModeAction {}
class StackTraceFake extends Fake implements StackTrace {}

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
    context = MockBuildContext();
    registerFallbackValue<StackTrace>(StackTraceFake());
    when(() => firebaseCrashlytics.recordError(any, any<StackTrace>(), reason: any(named: "reason")))
        .thenAnswer((realInvocation) async {
      print("firebase: ${realInvocation.positionalArguments.first}");
    });
    // when(firebaseCrashlytics.setUserIdentifier(any)).thenAnswer((_) async => print(_.positionalArguments.first));

    when(() => firebaseAnalytics.logEvent(
            name: any(named: "name"), parameters: any(named: "parameters")))
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
    var error = Exception("Test Error");
    var report = Report(
        error,
        StackTrace.current,
        DateTime.now(),
        <String, dynamic>{},
        <String, dynamic>{},
        <String, dynamic>{},
        FlutterErrorDetails(exception: error),
        PlatformType.android,
        null
    );
    reportMode.requestAction(report, context);
    await Future.delayed(Duration(milliseconds: 100));
    verify(() => firebaseCrashlytics.setCrashlyticsCollectionEnabled(true)).called(1);
    expect(verify(() => firebaseCrashlytics.setUserIdentifier(captureAny())).captured,
        ["guest"]);
    expect(verify(() => firebaseAnalytics.setUserId(captureAny())).captured, ["guest"]);
  });
}
