import 'package:flutter/material.dart';

class ConfirmationDialog {
  final String title;
  final String? description;
  final String negativeText;
  final String positiveText;
  final Function() payload;
  final Function()? onCancel;

  ConfirmationDialog({
    required this.title,
    this.description,
    required this.payload,
    this.onCancel,
    this.negativeText = 'Cancel',
    this.positiveText = 'Yes',
  });

  void launch(BuildContext context) => showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text(title),
            content: description != null ? Text(description!) : null,
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  if (onCancel != null) onCancel!();
                  Navigator.pop(dialogContext);
                },
                child: Text(negativeText),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  payload();
                },
                child: Text(positiveText),
              ),
            ],
          );
        },
      );
}
