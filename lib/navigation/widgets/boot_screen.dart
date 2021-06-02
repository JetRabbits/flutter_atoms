import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_atoms/navigation/blocs/boot/boot_bloc.dart';
import 'package:flutter_atoms/navigation/navigation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BootScreen extends StatelessWidget {
  final Widget? logo;

  final String? repeatLabelText;

  final String Function()? nextRoute;

  final BootBloc bootBloc;

  const BootScreen(this.bootBloc,
      {Key? key, this.logo, this.repeatLabelText, required this.nextRoute})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    log("build", name: "BootScreen");
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          logo ?? const FlutterLogo(size: 100),
          Padding(
              padding: const EdgeInsets.all(24.0),
              child: BlocConsumer<BootBloc, BootBlocState>(
                  bloc: bootBloc,
                  listener: (prev, current) {
                    log("${current}");
                    if (current == BootBlocState.READY) {
                      log("Application is ready");
                      nextRoute!().compass().replace().go();
                    }
                  },
                  builder: (context, state) {
                    if (state == BootBlocState.INIT) bootBloc.start();
                    if (state == BootBlocState.ERROR)
                      return buildRepeatButton();
                    return buildLoading();
                  })),
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
