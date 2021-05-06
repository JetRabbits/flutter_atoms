// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class AtomsStrings {
  AtomsStrings();

  static AtomsStrings? _current;

  static AtomsStrings get current {
    assert(_current != null, 'No instance of AtomsStrings was loaded. Try to initialize the AtomsStrings delegate before accessing AtomsStrings.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<AtomsStrings> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = AtomsStrings();
      AtomsStrings._current = instance;
 
      return instance;
    });
  } 

  static AtomsStrings of(BuildContext context) {
    final instance = AtomsStrings.maybeOf(context);
    assert(instance != null, 'No instance of AtomsStrings present in the widget tree. Did you add AtomsStrings.delegate in localizationsDelegates?');
    return instance!;
  }

  static AtomsStrings? maybeOf(BuildContext context) {
    return Localizations.of<AtomsStrings>(context, AtomsStrings);
  }

  /// `About application`
  String get about_application {
    return Intl.message(
      'About application',
      name: 'about_application',
      desc: '',
      args: [],
    );
  }

  /// `About company`
  String get about_company {
    return Intl.message(
      'About company',
      name: 'about_company',
      desc: '',
      args: [],
    );
  }

  /// `Application Settings`
  String get application_settings {
    return Intl.message(
      'Application Settings',
      name: 'application_settings',
      desc: '',
      args: [],
    );
  }

  /// `Application title`
  String get application_title_text {
    return Intl.message(
      'Application title',
      name: 'application_title_text',
      desc: '',
      args: [],
    );
  }

  /// `Build`
  String get build {
    return Intl.message(
      'Build',
      name: 'build',
      desc: '',
      args: [],
    );
  }

  /// `Company`
  String get company {
    return Intl.message(
      'Company',
      name: 'company',
      desc: '',
      args: [],
    );
  }

  /// `Contact e-mail`
  String get contact_email {
    return Intl.message(
      'Contact e-mail',
      name: 'contact_email',
      desc: '',
      args: [],
    );
  }

  /// `Copied to clipboard`
  String get copiedToClipboard {
    return Intl.message(
      'Copied to clipboard',
      name: 'copiedToClipboard',
      desc: '',
      args: [],
    );
  }

  /// `License agreement`
  String get license_agreement {
    return Intl.message(
      'License agreement',
      name: 'license_agreement',
      desc: '',
      args: [],
    );
  }

  /// `More`
  String get more_page {
    return Intl.message(
      'More',
      name: 'more_page',
      desc: '',
      args: [],
    );
  }

  /// `Platform`
  String get platform {
    return Intl.message(
      'Platform',
      name: 'platform',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get privacy_policy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacy_policy',
      desc: '',
      args: [],
    );
  }

  /// `3rd party licenses`
  String get thirdPartyLicenses {
    return Intl.message(
      '3rd party licenses',
      name: 'thirdPartyLicenses',
      desc: '',
      args: [],
    );
  }

  /// `Version`
  String get version_name {
    return Intl.message(
      'Version',
      name: 'version_name',
      desc: '',
      args: [],
    );
  }

  /// `Website`
  String get website {
    return Intl.message(
      'Website',
      name: 'website',
      desc: '',
      args: [],
    );
  }

  /// `What's New`
  String get whats_new {
    return Intl.message(
      'What\'s New',
      name: 'whats_new',
      desc: '',
      args: [],
    );
  }

  /// `Servers`
  String get servers {
    return Intl.message(
      'Servers',
      name: 'servers',
      desc: '',
      args: [],
    );
  }

  /// `Phone`
  String get phone {
    return Intl.message(
      'Phone',
      name: 'phone',
      desc: '',
      args: [],
    );
  }

  /// `repeat load`
  String get repeatLoad {
    return Intl.message(
      'repeat load',
      name: 'repeatLoad',
      desc: '',
      args: [],
    );
  }

  /// `История изменений`
  String get changesHistory {
    return Intl.message(
      'История изменений',
      name: 'changesHistory',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get today {
    return Intl.message(
      'Today',
      name: 'today',
      desc: '',
      args: [],
    );
  }

  /// `Tomorrow`
  String get tomorrow {
    return Intl.message(
      'Tomorrow',
      name: 'tomorrow',
      desc: '',
      args: [],
    );
  }

  /// `Yesterday`
  String get yesterday {
    return Intl.message(
      'Yesterday',
      name: 'yesterday',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<AtomsStrings> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<AtomsStrings> load(Locale locale) => AtomsStrings.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}