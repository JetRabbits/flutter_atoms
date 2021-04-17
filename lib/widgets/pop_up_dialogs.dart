import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_atoms/flutter_atoms.dart';
import 'package:flutter_atoms/integrations/analytics.dart';

///
/// Alert dialog with ok button and analytics send
///
Future<void> showAlertPopup(BuildContext context, String title, String detail) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) => AlertDialog(
      title: Text(title),
      content: Text(detail),
      actions: <Widget>[
        TextButton(
            child: Text('OK'),
            onPressed: () => loggableAction("dialog_ok", context, () => Navigator.of(context, rootNavigator: true).pop())),
      ],
    ),
  );
}

///
/// Return true if user choose yes, else return false. Analytics send support
///
Future<bool?> showYesNoPopup(BuildContext context, String title, String detail) {
  return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
            title: Text(title),
            content: Text(detail),
            actions: <Widget>[
              TextButton(
                  child: Text(AtomsStrings.of(context).yes_answer,
                      style: const TextStyle(fontSize: 16)),
                  onPressed: () =>
                    loggableAction("dialog_yes", context, () => Navigator.of(context, rootNavigator: true).pop(true))),
              TextButton(
                  child: Text(AtomsStrings.of(context).no_answer,
                      style: const TextStyle(fontSize: 16)),
                  onPressed: () =>
                    loggableAction("dialog_no", context, () => Navigator.of(context, rootNavigator: true).pop(false))),
            ],
          ));
}

///
/// Return true if user choose option1, else return false. Analytics send support.
///
Future<bool?> showOptionsPopup(BuildContext context, String title, String detail, String option1, String option2) {
  return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
            title: Text(title),
            content: Text(detail),
            actions: <Widget>[
              TextButton(
                  child: Text(option1,
                      style: const TextStyle(fontSize: 16)),
                  onPressed: () =>
                    loggableAction("dialog_option1", context, () => Navigator.of(context, rootNavigator: true).pop(true))),
              TextButton(
                  child: Text(option2,
                      style: const TextStyle(fontSize: 16)),
                  onPressed: () =>
                    loggableAction("dialog_option2", context, () => Navigator.of(context, rootNavigator: true).pop(false))),
            ],
          ));
}
