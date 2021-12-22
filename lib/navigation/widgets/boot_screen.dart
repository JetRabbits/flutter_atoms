import 'package:flutter/material.dart';
import 'package:flutter_atoms/logging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/boot/boot_bloc.dart';

class BootScreen extends StatelessWidget with Loggable {
  final Widget? logo;

  final String? repeatLabelText;
  final VoidCallback? onBugReport;

  final BootBloc bootBloc;

  EdgeInsets Function(BuildContext context)? repeatButtonPadding;

  BootScreen(this.bootBloc,
      {Key? key,
      this.logo,
      this.repeatLabelText,
      this.repeatButtonPadding,
      this.onBugReport})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.finest("build");
    return Scaffold(
      body: BlocConsumer<BootBloc, BootBlocState>(
        bloc: bootBloc,
        listener: (context, state) {
        },
        builder: (context, state) {
          logger.finest("$state");
          if (state == BootBlocState.ERROR) {
            return buildErrorState(context);
          }
          return buildLoadingState(context);
        },
      ),
    );
  }

  Widget buildLoadingState(BuildContext context) => Stack(children: <Widget>[
        logo ?? const FlutterLogo(size: 100),
        Padding(
            padding: repeatButtonPadding != null
                ? repeatButtonPadding!(context)
                : EdgeInsets.zero,
            child:
                Align(alignment: Alignment.bottomCenter, child: buildLoading()))
      ]);

  Widget buildErrorState(BuildContext context) => Stack(children: <Widget>[
        logo ?? const FlutterLogo(size: 100),
        Padding(
            padding: repeatButtonPadding != null
                ? repeatButtonPadding!(context)
                : EdgeInsets.zero,
            child: Align(
                alignment: Alignment.bottomCenter, child: buildRepeatButton())),
    if (onBugReport != null)
      Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: IconButton(
                icon: Icon(Icons.bug_report), onPressed: onBugReport),
          )),
      ]);

  Widget buildRepeatButton() => Center(
      child: TextButton(
        onPressed: () => bootBloc.start(),
        child: SizedBox(
          width: 200,
          height: 32,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.refresh,
                size: 24,
              ),
              SizedBox(width: 4),
              Text(
                repeatLabelText ?? "repeat load",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );

  Widget buildLoading() => SizedBox(
        height: 100, child: Center(child: const CircularProgressIndicator()));
}
