import 'package:flutter/material.dart';
import 'package:integration_bee_helper/models/agenda_item_model.dart';
import 'package:integration_bee_helper/services/agenda_items_service.dart';
import 'package:integration_bee_helper/widgets/cancel_save_buttons.dart';

class AgendaItemText extends StatefulWidget {
  final AgendaItemModel agendaItem;
  final AgendaItemsService service;

  const AgendaItemText({
    super.key,
    required this.agendaItem,
    required this.service,
  });

  @override
  State<AgendaItemText> createState() => _AgendaItemTextState();
}

class _AgendaItemTextState extends State<AgendaItemText> {
  bool hasChanged = false;

  late String text;

  late TextEditingController controller;

  @override
  void initState() {
    text = widget.agendaItem.text!;

    controller = TextEditingController(text: text);

    super.initState();
  }

  @override
  void didUpdateWidget(covariant AgendaItemText oldWidget) {
    text = widget.agendaItem.text!;

    controller.text = text;

    hasChanged = false;

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Text',
          ),
          controller: controller,
          onChanged: (v) => setState(() {
            text = v;
            hasChanged = true;
          }),
          maxLines: 3,
        ),
        if (hasChanged)
          CancelSaveButtons(
            onCancel: () {
              setState(() {
                hasChanged = false;
                text = widget.agendaItem.text!;
                controller.text = text;
              });
            },
            onSave: () async {
              await widget.service.editAgendaItemText(
                widget.agendaItem.id!,
                text: text,
              );
              setState(() => hasChanged = false);
            },
          ),
      ],
    );
  }
}
