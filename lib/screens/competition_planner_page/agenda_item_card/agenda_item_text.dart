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

  late String title;
  late String subtitle;

  late TextEditingController titleController;
  late TextEditingController subtitleController;

  @override
  void initState() {
    title = widget.agendaItem.title!;
    subtitle = widget.agendaItem.subtitle!;

    titleController = TextEditingController(text: title);
    subtitleController = TextEditingController(text: subtitle);

    super.initState();
  }

  @override
  void didUpdateWidget(covariant AgendaItemText oldWidget) {
    reset();

    super.didUpdateWidget(oldWidget);
  }

  void reset() {
    title = widget.agendaItem.title!;
    subtitle = widget.agendaItem.subtitle!;

    titleController.text = title;
    subtitleController.text = subtitle;

    hasChanged = false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Title',
          ),
          controller: titleController,
          onChanged: (v) => setState(() {
            title = v;
            hasChanged = true;
          }),
          maxLines: 1,
        ),
        TextField(
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Subtitle',
          ),
          controller: subtitleController,
          onChanged: (v) => setState(() {
            subtitle = v;
            hasChanged = true;
          }),
          maxLines: 1,
        ),
        if (hasChanged)
          CancelSaveButtons(
            onCancel: () {
              setState(() {
                reset();
              });
            },
            onSave: () async {
              await widget.service.editAgendaItemText(
                widget.agendaItem,
                title: title,
                subtitle: subtitle,
              );
              setState(() => hasChanged = false);
            },
          ),
      ],
    );
  }
}
