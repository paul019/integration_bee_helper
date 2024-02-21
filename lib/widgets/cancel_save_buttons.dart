import 'package:flutter/material.dart';

class CancelSaveButtons extends StatelessWidget {
  final Function() onCancel;
  final Function() onSave;

  const CancelSaveButtons({
    super.key,
    required this.onCancel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        Row(
          children: [
            Expanded(child: Container()),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: TextButton(
                onPressed: onCancel,
                child: const Text('Cancel'),
              ),
            ),
            FilledButton(
              onPressed: onSave,
              child: const Text('Save changes'),
            ),
          ],
        ),
      ],
    );
  }
}
