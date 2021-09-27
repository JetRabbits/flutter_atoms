import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_atoms/generated/l10n.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log("build", name: "NotFoundScreen");
    return Scaffold(
      body: Center(child: Text(AtomsStrings.of(context).page_not_found)),
    );
  }
}
