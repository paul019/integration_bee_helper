import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

extension ExceptionExtension on Exception {
  void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => PointerInterceptor(
        child: AlertDialog(
          title: const Text('An error occurred'),
          content: Text(toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Ok'),
            ),
          ],
        ),
      ),
    );
  }
}
