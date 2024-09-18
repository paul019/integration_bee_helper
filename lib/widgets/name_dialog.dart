import 'package:flutter/material.dart';
import 'package:integration_bee_helper/services/basic_services/intl_service.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class NameDialog extends StatefulWidget {
  final String title;
  final String hintText;
  final String initialValue;
  final void Function(String) onConfirm;

  const NameDialog({
    Key? key,
    required this.title,
    required this.hintText,
    this.initialValue = '',
    required this.onConfirm,
  }) : super(key: key);

  static void show({
    required BuildContext context,
    required String title,
    required String hintText,
    String initialValue = '',
    required void Function(String) onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) => NameDialog(
        title: title,
        hintText: hintText,
        initialValue: initialValue,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  State<NameDialog> createState() => _NameDialogState();
}

class _NameDialogState extends State<NameDialog> {
  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController(text: widget.initialValue);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PointerInterceptor(
      child: AlertDialog(
        title: Text(widget.title),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: widget.hintText,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(MyIntl.of(context).cancel),
          ),
          TextButton(
            onPressed: () {
              widget.onConfirm(controller.text);
              Navigator.of(context).pop();
            },
            child: Text(MyIntl.of(context).confirm),
          ),
        ],
      ),
    );
  }
}