import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_atoms/generated/l10n.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log("build", name: "ErrorScreen");
    return Scaffold(
      body: Center(child: Text(AtomsStrings.of(context).error_during_navigation)),
    );
  }
}
