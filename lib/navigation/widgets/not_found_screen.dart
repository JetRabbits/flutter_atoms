import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_atoms/navigation/blocs/boot/boot_bloc.dart';
import 'package:flutter_atoms/navigation/navigation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen(
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    log("build", name: "BootScreen");
    return Scaffold(
      body: Center(child: Text('Страница не найдена')),
    );
  }
}
