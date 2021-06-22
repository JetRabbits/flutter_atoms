import 'dart:developer';

import 'package:flutter/material.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log("build", name: "BootScreen");
    return Scaffold(
      body: Center(child: Text('Страница не найдена')),
    );
  }
}
