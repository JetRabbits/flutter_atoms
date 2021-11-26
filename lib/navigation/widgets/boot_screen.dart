import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_atoms/logging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../navigation.dart';
import '../blocs/boot/boot_bloc.dart';

class BootScreen extends StatelessWidget with Loggable{
  final Widget? logo;

  final String? repeatLabelText;

  final BootBloc bootBloc;

  EdgeInsets Function(BuildContext context)? repeatButtonPadding;

  BootScreen(this.bootBloc,
      {Key? key,
      this.logo,
      this.repeatLabelText,
      this.repeatButtonPadding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.finest("build");
    return Scaffold(
      body: Stack(
        children: <Widget>[
          logo ?? const FlutterLogo(size: 100),
          Padding(
            padding: repeatButtonPadding != null ? repeatButtonPadding!(context) : EdgeInsets.zero,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: BlocConsumer<BootBloc, BootBlocState>(
                  bloc: bootBloc,
                  listener: (context, state) {
                    // print("!!!!!!");
                    // log("$state", name: "BootScreen");
                    // if (state == BootBlocState.READY) {
                    //   log("Application is ready", name: "BootScreen");
                    //   nextRoute!().compass().replace().go();
                    // } else
                    // {
                    //   log("Application boot is failed", name: "BootScreen");
                    // }
                  },
                  builder: (context, state) {
                    logger.finest("$state");

                    // if (state == BootBlocState.INIT) bootBloc.start();
                    if (state == BootBlocState.ERROR)
                      return buildRepeatButton();
                    return buildLoading();
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRepeatButton() {
    return Center(
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
  }

  Widget buildLoading() {
    return SizedBox(
        height: 100, child: Center(child: const CircularProgressIndicator()));
  }
}
