import 'package:flutter/material.dart';
import 'package:integration_bee_helper/extensions/exception_extension.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_phase.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_text.dart';
import 'package:integration_bee_helper/services/basic_services/intl_service.dart';
import 'package:integration_bee_helper/widgets/cancel_save_buttons.dart';

class AgendaItemText extends StatefulWidget {
  final AgendaItemModelText agendaItem;

  const AgendaItemText({
    super.key,
    required this.agendaItem,
  });

  @override
  State<AgendaItemText> createState() => _AgendaItemTextState();
}

class _AgendaItemTextState extends State<AgendaItemText> {
  bool hasChanged = false;

  late String title;
  late String subtitle;
  late String imageUrl;

  late TextEditingController titleController;
  late TextEditingController subtitleController;
  late TextEditingController imageUrlController;

  @override
  void initState() {
    title = widget.agendaItem.title;
    subtitle = widget.agendaItem.subtitle;
    imageUrl = widget.agendaItem.imageUrl;

    titleController = TextEditingController(text: title);
    subtitleController = TextEditingController(text: subtitle);
    imageUrlController = TextEditingController(text: imageUrl);

    super.initState();
  }

  @override
  void didUpdateWidget(covariant AgendaItemText oldWidget) {
    reset();

    super.didUpdateWidget(oldWidget);
  }

  void reset() {
    title = widget.agendaItem.title;
    subtitle = widget.agendaItem.subtitle;
    imageUrl = widget.agendaItem.imageUrl;

    titleController.text = title;
    subtitleController.text = subtitle;
    imageUrlController.text = imageUrl;

    hasChanged = false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 100,
              child: Text(
                MyIntl.S.titleColon,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: TextField(
                enabled: widget.agendaItem.phase != AgendaItemPhase.over,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: MyIntl.S.title,
                ),
                controller: titleController,
                onChanged: (v) => setState(() {
                  title = v;
                  hasChanged = true;
                }),
                maxLines: 1,
              ),
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(
              width: 100,
              child: Text(
                MyIntl.S.subtitleColon,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: TextField(
                enabled: widget.agendaItem.phase != AgendaItemPhase.over,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: MyIntl.S.subtitle,
                ),
                controller: subtitleController,
                onChanged: (v) => setState(() {
                  subtitle = v;
                  hasChanged = true;
                }),
                maxLines: 1,
              ),
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(
              width: 100,
              child: Text(
                MyIntl.S.imageUrlColon,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: TextField(
                enabled: widget.agendaItem.phase != AgendaItemPhase.over,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: MyIntl.S.imageUrl,
                ),
                controller: imageUrlController,
                onChanged: (v) => setState(() {
                  imageUrl = v;
                  hasChanged = true;
                }),
                maxLines: 1,
              ),
            ),
          ],
        ),
        if (hasChanged)
          CancelSaveButtons(
            onCancel: () {
              setState(() {
                reset();
              });
            },
            onSave: () async {
              try {
                await widget.agendaItem.editStatic(
                  title: title,
                  subtitle: subtitle,
                  imageUrl: imageUrl,
                );
                setState(() => hasChanged = false);
              } on Exception catch (e) {
                if (context.mounted) e.show(context);
              }
            },
          ),
      ],
    );
  }
}
