import 'package:flutter/material.dart';
import 'package:flutter_atoms/flutter_atoms.dart';
import 'package:flutter_atoms/integrations/analytics.dart';

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

Future<bool> showYesNoPopup(BuildContext context, String title, String detail) {
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
