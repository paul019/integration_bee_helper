import 'package:flutter/material.dart';
import 'package:integration_bee_helper/extensions/exception_extension.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_phase.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_text.dart';
import 'package:integration_bee_helper/services/basic_services/intl_service.dart';
import 'package:integration_bee_helper/widgets/cancel_save_buttons.dart';
import 'package:integration_bee_helper/widgets/image_upload_widget.dart';

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

  late TextEditingController titleController;
  late TextEditingController subtitleController;

  @override
  void initState() {
    title = widget.agendaItem.title;
    subtitle = widget.agendaItem.subtitle;

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
    title = widget.agendaItem.title;
    subtitle = widget.agendaItem.subtitle;

    titleController.text = title;
    subtitleController.text = subtitle;

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
                MyIntl.of(context).titleColon,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: TextField(
                enabled: widget.agendaItem.phase != AgendaItemPhase.over,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: MyIntl.of(context).title,
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
                MyIntl.of(context).subtitleColon,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: TextField(
                enabled: widget.agendaItem.phase != AgendaItemPhase.over,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: MyIntl.of(context).subtitle,
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
        const Divider(),
        Row(
          children: [
            SizedBox(
              width: 100,
              child: Text(
                MyIntl.of(context).imageColon,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ImageUploadWidget(
              imageUrl: widget.agendaItem.imageUrl,
              onUpload: (image) {
                widget.agendaItem.uploadImage(
                  image: image,
                  onError: (e) => e.show(context),
                );
              },
              onDelete: () {
                widget.agendaItem.deleteImage(
                  path: widget.agendaItem.imageUrl!,
                  onError: (e) => e.show(context),
                );
              },
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
