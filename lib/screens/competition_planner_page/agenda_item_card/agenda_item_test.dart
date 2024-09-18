import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:integration_bee_helper/extensions/exception_extension.dart';
import 'package:integration_bee_helper/extensions/list_extension.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_phase.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_test.dart';
import 'package:integration_bee_helper/services/basic_services/intl_service.dart';
import 'package:integration_bee_helper/widgets/cancel_save_buttons.dart';
import 'package:integration_bee_helper/widgets/name_dialog.dart';
import 'package:integration_bee_helper/widgets/wrap_list.dart';

class AgendaItemTest extends StatefulWidget {
  final AgendaItemModelTest agendaItem;

  const AgendaItemTest({
    super.key,
    required this.agendaItem,
  });

  @override
  State<AgendaItemTest> createState() => _AgendaItemTestState();
}

class _AgendaItemTestState extends State<AgendaItemTest> {
  bool hasChanged = false;

  late String title;
  late String remarks;
  late String integralsCodes;

  late TextEditingController titleController;
  late TextEditingController remarksController;
  late TextEditingController integralsCodesController;

  @override
  void initState() {
    title = widget.agendaItem.title;
    remarks = widget.agendaItem.remarks;
    integralsCodes = widget.agendaItem.integralsCodes.join(',');

    titleController = TextEditingController(text: title);
    remarksController = TextEditingController(text: remarks);
    integralsCodesController = TextEditingController(text: integralsCodes);

    super.initState();
  }

  @override
  void didUpdateWidget(covariant AgendaItemTest oldWidget) {
    reset();

    super.didUpdateWidget(oldWidget);
  }

  void reset() {
    title = widget.agendaItem.title;
    remarks = widget.agendaItem.remarks;
    integralsCodes = widget.agendaItem.integralsCodes.join(',');

    titleController.text = title;
    remarksController.text = remarks;
    integralsCodesController.text = integralsCodes;

    hasChanged = false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                  hintText: MyIntl.of(context).titleOptional,
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
        const Divider(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 100,
              child: Text(
                MyIntl.of(context).remarksColon,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: TextField(
                enabled: widget.agendaItem.phase != AgendaItemPhase.over,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: MyIntl.of(context).remarks,
                ),
                controller: remarksController,
                onChanged: (v) => setState(() {
                  remarks = v;
                  hasChanged = true;
                }),
                maxLines: 5,
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
                MyIntl.of(context).competitorsColon,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: WrapList<String>(
                items: widget.agendaItem.competitorNames,
                itemBuilder: (context, index, item) => BasicWrapListItem(
                  item: Text(item),
                  showRemove: true,
                  onRemove: () async {
                    final competitorNames = widget.agendaItem.competitorNames;
                    competitorNames.removeAt(index);

                    try {
                      await widget.agendaItem.editStatic(
                        competitorNames: competitorNames,
                      );
                    } on Exception catch (e) {
                      if (context.mounted) e.show(context);
                    }
                  },
                ),
                onAdd: () {
                  NameDialog.show(
                    context: context,
                    title: MyIntl.of(context).addCompetitor,
                    hintText: MyIntl.of(context).competitionName,
                    onConfirm: (name) async {
                      final competitorNames = widget.agendaItem.competitorNames;
                      competitorNames.add(name);

                      try {
                        await widget.agendaItem.editStatic(
                          competitorNames: competitorNames,
                        );
                      } on Exception catch (e) {
                        if (context.mounted) e.show(context);
                      }
                    },
                  );
                },
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
                MyIntl.of(context).integralsColon,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: TextField(
                enabled: widget.agendaItem.phase != AgendaItemPhase.over,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: MyIntl.of(context).codes,
                ),
                controller: integralsCodesController,
                onChanged: (v) => setState(() {
                  integralsCodes = v;
                  hasChanged = true;
                }),
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
                  integralsCodes:
                      integralsCodes.split(',').deleteEmptyEntries(),
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
