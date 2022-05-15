import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_atoms/flutter_atoms.dart';
import 'package:flutter_whatsnew/flutter_whatsnew.dart';
import 'package:intl/intl.dart';

class WhatNewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: AutoSizeText(AtomsStrings.of(context).whats_new)),
      body: SafeArea(
          child: WhatsNewPage.changelog(
              path: Intl.getCurrentLocale() == 'ru'
                  ? 'CHANGELOG_ru.md'
                  : 'CHANGELOG_en.md', title: Text("История изменений"),buttonText: Text("Далее"),)),
    );
  }
}
