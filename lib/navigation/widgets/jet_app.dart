import 'dart:developer';

import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_atoms/flutter_atoms.dart';
// import 'package:flutter_atoms/i18n/big_composite_message_lookup.dart';
import 'package:flutter_atoms/navigation/blocs/boot/boot_bloc.dart';
import 'package:flutter_atoms/navigation/widgets/navigation_error_screen.dart';
import 'package:flutter_atoms/navigation/widgets/not_found_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:persist_theme/persist_theme.dart';

import '../../navigation.dart';
import 'boot_screen.dart';
import 'root_router_delegate.dart';

// ignore: must_be_immutable
class JetApp extends StatefulWidget {
  final List<RepositoryProvider>? topLevelProviders;

  final GenerateAppTitle onGenerateTitle;

  final NavigationModel navigationModel;

  WidgetBuilder? bootWidgetBuilder;

  final Widget? logo;

  final String Function(BuildContext)? repeatLoadLabel;

  final Future<bool> Function()? onAppStart;

  final String Function()? nextRoute;

  final ThemeModel Function(BuildContext context)? themeModelBuilder;

  final Iterable<Locale>? supportedLocales;

  final List<LocalizationsDelegate<dynamic>>? localizationsDelegates;

  final ThemeData? bootPageThemeData;

  final bool useAtomsIntl;

  late final BootBloc bootBloc;

  EdgeInsets Function(BuildContext context)? repeatButtonPadding;

  JetApp({
    Key? key,
    required this.navigationModel,
    required this.onGenerateTitle,
    this.onAppStart,
    this.nextRoute,
    this.logo,
    this.repeatButtonPadding,
    this.bootPageThemeData,
    this.repeatLoadLabel,
    this.bootWidgetBuilder,
    this.topLevelProviders,
    this.themeModelBuilder,
    this.supportedLocales,
    this.localizationsDelegates,
    this.useAtomsIntl = true,
  }) : super(key: key) {
    setupNavigation(navigationModel);

    if (useAtomsIntl) {
      initializeBigIntlMessageLookup();
      localizationsDelegates!.add(AtomsStrings.delegate);
    }
    bootBloc = GetIt.I<BootBloc>()
      ..nextRoute = nextRoute
      ..onStart = onAppStart!;
    if (navigationModel.pagesMap["/"] == null) {
      if (bootWidgetBuilder == null) {
        bootWidgetBuilder = (context) {
          return Theme(
            data: bootPageThemeData ?? ThemeData.light(),
            child: BootScreen(bootBloc,
                logo: logo,
                repeatButtonPadding: repeatButtonPadding,
                repeatLabelText: repeatLoadLabel == null
                    ? AtomsStrings.of(context).repeatLoad
                    : repeatLoadLabel!(context)),
          );
        };
      }
      navigationModel.addRoutePattern("/", bootWidgetBuilder);
      if (navigationModel.pagesMap["/404"] == null) {
        navigationModel.addRoutePattern(
            "/404", (context) => const NotFoundScreen());
      }
      if (navigationModel.pagesMap["/error"] == null) {
        navigationModel.addRoutePattern(
            "/error", (context) => const ErrorScreen());
      }
    }
  }

  @override
  _JetAppState createState() => _JetAppState();
}

class _JetAppState extends State<JetApp> {
  late ThemeModel _themeModel;

  @override
  Widget build(BuildContext context) {
    return PersistTheme(
      model: _themeModel,
      builder: (context, themeModel, child) {
        return MaterialApp.router(
          localizationsDelegates: widget.localizationsDelegates,
          supportedLocales: widget.supportedLocales!,
          debugShowCheckedModeBanner: false,
          theme: themeModel.theme,
          onGenerateTitle: widget.onGenerateTitle,
          routerDelegate: GetIt.I<RootRouterDelegate>(),
          routeInformationParser: widget.navigationModel,
          routeInformationProvider:
              GetIt.I<CompassNavigationState>().routeInformationProvider,
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    log("JetApp initState");
    log("widget.bootBloc.state = ${widget.bootBloc.state}");

    if (widget.bootBloc.state == BootBlocState.READY) {
      log("Reset boot");
      widget.bootBloc.reset();
    }

    widget.bootBloc.start();

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
