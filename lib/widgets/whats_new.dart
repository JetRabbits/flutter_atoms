// ignore: import_of_legacy_library_into_null_safe
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_atoms/flutter_atoms.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_whatsnew/flutter_whatsnew.dart';
import 'package:intl/intl.dart';

class WhatNewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: AutoSizeText(AtomsStrings.of(context).whats_new)),
      body: SafeArea(
        child: ChangeLogView(path: Intl.getCurrentLocale() == 'ru' ? 'CHANGELOG_ru.md' : 'CHANGELOG_en.md')
      ),
    );
  }
}
