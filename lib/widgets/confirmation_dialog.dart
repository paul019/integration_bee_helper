import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class ConfirmationDialog {
  final String title;
  final String? description;
  final String negativeText;
  final String positiveText;
  final Function() payload;
  final Function()? onCancel;
  final bool? bypassConfirmation;

  ConfirmationDialog({
    required this.title,
    this.description,
    required this.payload,
    this.onCancel,
    this.negativeText = 'Cancel',
    this.positiveText = 'Yes',
    this.bypassConfirmation,
  });

  void launch(BuildContext context) {
    if(bypassConfirmation == true) {
      payload();
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return PointerInterceptor(
          child: AlertDialog(
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
          ),
        );
      },
    );
  }
}
