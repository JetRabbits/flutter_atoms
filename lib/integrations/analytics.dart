import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

///
/// Aggregates together both Google Analytics and Google Crashlytics features.
/// So this way allow to see analytics events and errors in user session context
/// and it is useful to restore step by step scenario when app is crashed or
/// none-critical error is occurred.
///
/// Usage:
///
/// main.dart
/// ---
/// void main() async {
///   await Analytics.initialize();
///   // Call configure everytime you new new callbacks or reconfigure
///   await Analytics().configure(
///     options: AnalyticsOptions(onUserId: ..., onCustomProperties: ...)
///   )
/// }
///
class Analytics {
  static final Analytics _instance = Analytics._();

  static Future<void> initialize() async {
    print("Firebase.initialize");
    await Firebase.initializeApp();
    await Analytics().configure(
        analytics: FirebaseAnalytics(),
        crashlytics: FirebaseCrashlytics.instance,
        options: AnalyticsOptions.guestOptions);
  }

  AnalyticsOptions options;

  Analytics._();

  factory Analytics() {
    return _instance;
  }

  FirebaseAnalytics _analytics;
  FirebaseAnalyticsObserver _observer;
  FirebaseCrashlytics _crashlytics;
  BuildContext _context;

  Future<void> configure(
      {FirebaseCrashlytics crashlytics,
      FirebaseAnalytics analytics,
      AnalyticsOptions options}) async {
    print("Analytics configure");
    if (crashlytics != null) {
      _crashlytics = crashlytics;
      await _crashlytics.setCrashlyticsCollectionEnabled(true);
    }
    print("Analytics object: $analytics");
    if (analytics != null) {
      _analytics = analytics;
      print("Analytics create FirebaseAnalyticsObserver");
      _observer = FirebaseAnalyticsObserver(analytics: _analytics);
    }
    this.options = options;
  }

  get observer => _observer;

  factory Analytics.of(BuildContext context) {
    _instance._context = context;
    return _instance;
  }

  Future<void> _fillParams(BuildContext context) async {
    if (context == null) {
      print(
          "Can not set analytics properties due to null context. Consider use Analytics.of()");
      return;
    }

    try {
      if (options?.onUserId != null) {
        String _userId = await options.onUserId(context);
        await _analytics.setUserId(_userId);
        await _crashlytics.setUserIdentifier(_userId);
      }
    } catch (e, stack) {
      print("Can not set user id: $e");
      print(stack);
    }

    try {
      if (options?.onCustomProperties != null) {
        Map<String, String> _props = await options.onCustomProperties(context);
        await Future.forEach(_props.keys, (key) async {
          await _analytics.setUserProperty(name: key, value: _props[key]);
          await _crashlytics.setCustomKey(key, _props[key]);
        });
      }
    } catch (e) {
      print("Can not set analytics properties");
    }
  }

  void logTapEvent(String buttonName, {Map<String, dynamic> parameters}) {
    String eventName = "tap_$buttonName";
    _fillParams(_context).then(
        (_) => _analytics?.logEvent(name: eventName, parameters: parameters));
  }

  void logError(exception, stackTrace, Map<String, dynamic> parameters) {
    String eventName = "application_error_event";
    _fillParams(_context).then((_) async {
      await _analytics?.logEvent(name: eventName, parameters: parameters);
      await _crashlytics?.recordError(exception, stackTrace);
    });
  }
}

class AnalyticsOptions {
  static AnalyticsOptions guestOptions =
      AnalyticsOptions(onUserId: (_) async => "guest");
  final Future<String> Function(BuildContext context) onUserId;
  final Future<Map<String, String>> Function(BuildContext context)
      onCustomProperties;

  AnalyticsOptions({this.onUserId, this.onCustomProperties});
}

loggableAction(String actionName, BuildContext context, VoidCallback action) {
  Analytics.of(context).logTapEvent(actionName);
  action();
}
