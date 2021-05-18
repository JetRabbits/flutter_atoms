import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_atoms/flutter_atoms.dart';
import 'package:flutter_atoms/i18n/big_composite_message_lookup.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:persist_theme/persist_theme.dart';

import '../navigation.dart';
import 'app_router_delegate.dart';
import 'boot_screen.dart';

// ignore: must_be_immutable
class JetApp extends StatefulWidget {
  final List<RepositoryProvider>? topLevelProviders;

  final GenerateAppTitle onGenerateTitle;

  final NavigationModel navigationModel;

  WidgetBuilder? bootWidget;

  final Widget? logo;

  final String Function(BuildContext)? repeatLoadLabel;

  final Future<bool> Function()? onAppStart;

  final String Function()? nextRoute;

  final ThemeModel Function(BuildContext context)? themeModelBuilder;

  final Iterable<Locale>? supportedLocales;

  final List<LocalizationsDelegate<dynamic>>? localizationsDelegates;

  final ThemeData? bootPageThemeData;

  final bool useAtomsIntl;

  JetApp({
    Key? key,
    required this.navigationModel,
    required this.onGenerateTitle,
    this.onAppStart,
    this.nextRoute,
    this.logo,
    this.bootPageThemeData,
    this.repeatLoadLabel,
    this.bootWidget,
    this.topLevelProviders,
    this.themeModelBuilder,
    this.supportedLocales,
    this.localizationsDelegates,
    this.useAtomsIntl = true,
  }) : super(key: key) {
    atomsSetup(navigationModel);

    if (useAtomsIntl) {
      initializeBigIntlMessageLookup();
      localizationsDelegates!.add(AtomsStrings.delegate);
    }
    if (navigationModel.pagesMap["/"] == null) {
      if (bootWidget == null) {
        assert(nextRoute != null, "Next route should be defined");
        assert(onAppStart != null, "onAppStart should be defined");
        bootWidget = (context) {
          return Theme(
            data: bootPageThemeData ?? ThemeData.light(),
            child: BootScreen(GetIt.I()..onStart = onAppStart!,
                logo: logo,
                repeatLabelText: repeatLoadLabel == null
                    ? AtomsStrings.of(context).repeatLoad
                    : repeatLoadLabel!(context),
                nextRoute: nextRoute),
          );
        };
      }
      navigationModel.addPath("/", bootWidget);
    }
  }

  @override
  _JetAppState createState() => _JetAppState();
}

class _JetAppState extends State<JetApp> {

  late ThemeModel _themeModel;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider<VersionModel>(
              create: (context) => VersionModel()..load()),
        ]..addAll(widget.topLevelProviders ?? []),
        child: PersistTheme(
          model: _themeModel,
          builder: (context, themeModel, child) {
            return MaterialApp.router(
              localizationsDelegates: widget.localizationsDelegates,
              supportedLocales: widget.supportedLocales!,
              debugShowCheckedModeBanner: false,
              theme: themeModel.theme,
              onGenerateTitle: widget.onGenerateTitle,
              routerDelegate: GetIt.I<JetAppRouterDelegate>(),
              routeInformationParser: widget.navigationModel,
            );
          },
        ));
  }

  @override
  void initState() {
    super.initState();
    _themeModel = widget.themeModelBuilder != null
        ? widget.themeModelBuilder!(context)
        : defaultThemeModel();
  }

  ThemeModel defaultThemeModel() {
    var _textTheme =
        ThemeData.dark().textTheme.apply(fontFamily: 'Core Sans DS');

    return ThemeModel(
      customLightTheme: ThemeData(fontFamily: 'Core Sans DS'),
      customDarkTheme: ThemeData.dark().copyWith(textTheme: _textTheme),
    );
  }
}



