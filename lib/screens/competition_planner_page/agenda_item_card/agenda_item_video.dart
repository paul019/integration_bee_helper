import 'package:flutter/material.dart';
import 'package:integration_bee_helper/extensions/exception_extension.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_phase.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_video.dart';
import 'package:integration_bee_helper/services/basic_services/intl_service.dart';
import 'package:integration_bee_helper/widgets/cancel_save_buttons.dart';

class AgendaItemVideo extends StatefulWidget {
  final AgendaItemModelVideo agendaItem;

  const AgendaItemVideo({
    super.key,
    required this.agendaItem,
  });

  @override
  State<AgendaItemVideo> createState() => _AgendaItemVideoState();
}

class _AgendaItemVideoState extends State<AgendaItemVideo> {
  bool hasChanged = false;

  late String youtubeVideoId;
  late TextEditingController youtubeVideoIdController;

  @override
  void initState() {
    youtubeVideoId = widget.agendaItem.youtubeVideoId;
    youtubeVideoIdController = TextEditingController(text: youtubeVideoId);

    super.initState();
  }

  @override
  void didUpdateWidget(covariant AgendaItemVideo oldWidget) {
    reset();

    super.didUpdateWidget(oldWidget);
  }

  void reset() {
    youtubeVideoId = widget.agendaItem.youtubeVideoId;
    youtubeVideoIdController.text = youtubeVideoId;

    hasChanged = false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 150,
              child: Text(
                MyIntl.of(context).youtubeVideoIdColon,
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
                controller: youtubeVideoIdController,
                onChanged: (v) => setState(() {
                  youtubeVideoId = v;
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
                  youtubeVideoId: youtubeVideoId,
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
