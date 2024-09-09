import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:integration_bee_helper/extensions/exception_extension.dart';
import 'package:integration_bee_helper/extensions/list_extension.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_phase.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_test.dart';
import 'package:integration_bee_helper/services/basic_services/intl_service.dart';
import 'package:integration_bee_helper/widgets/cancel_save_buttons.dart';

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
  late String competitorNames;
  late String integralsCodes;

  late TextEditingController titleController;
  late TextEditingController remarksController;
  late TextEditingController competitorNamesController;
  late TextEditingController integralsCodesController;

  @override
  void initState() {
    title = widget.agendaItem.title;
    remarks = widget.agendaItem.remarks;
    competitorNames = widget.agendaItem.competitorNames.join(',');
    integralsCodes = widget.agendaItem.integralsCodes.join(',');

    titleController = TextEditingController(text: title);
    remarksController = TextEditingController(text: remarks);
    competitorNamesController = TextEditingController(text: competitorNames);
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
    competitorNames = widget.agendaItem.competitorNames.join(',');
    integralsCodes = widget.agendaItem.integralsCodes.join(',');

    titleController.text = title;
    remarksController.text = remarks;
    competitorNamesController.text = competitorNames;
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
                MyIntl.S.titleColon,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: TextField(
                enabled: widget.agendaItem.phase != AgendaItemPhase.over,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: MyIntl.S.titleOptional,
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
                MyIntl.S.remarksColon,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: TextField(
                enabled: widget.agendaItem.phase != AgendaItemPhase.over,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: MyIntl.S.remarks,
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
                MyIntl.S.competitorsColon,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: TextField(
                enabled: widget.agendaItem.phase != AgendaItemPhase.over,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: MyIntl.S.competitors,
                ),
                controller: competitorNamesController,
                onChanged: (v) => setState(() {
                  competitorNames = v;
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
                MyIntl.S.integralsColon,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: TextField(
                enabled: widget.agendaItem.phase != AgendaItemPhase.over,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: MyIntl.S.codes,
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
                  competitorNames:
                      competitorNames.split(',').deleteEmptyEntries(),
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
