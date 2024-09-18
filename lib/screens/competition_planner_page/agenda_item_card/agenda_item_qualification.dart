import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:integration_bee_helper/extensions/exception_extension.dart';
import 'package:integration_bee_helper/extensions/list_extension.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_phase.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_qualification.dart';
import 'package:integration_bee_helper/services/basic_services/intl_service.dart';
import 'package:integration_bee_helper/widgets/cancel_save_buttons.dart';
import 'package:integration_bee_helper/widgets/name_dialog.dart';
import 'package:integration_bee_helper/widgets/wrap_list.dart';

class AgendaItemQualification extends StatefulWidget {
  final AgendaItemModelQualification agendaItem;

  const AgendaItemQualification({
    super.key,
    required this.agendaItem,
  });

  @override
  State<AgendaItemQualification> createState() =>
      _AgendaItemQualificationState();
}

class _AgendaItemQualificationState extends State<AgendaItemQualification> {
  bool hasChanged = false;

  late String title;
  late String integralsCodes;
  late String spareIntegralsCodes;
  late String timeLimitPerIntegral;
  late String timeLimitPerSpareIntegral;

  late TextEditingController titleController;
  late TextEditingController integralsCodesController;
  late TextEditingController spareIntegralsCodesController;
  late TextEditingController timeLimitPerIntegralController;
  late TextEditingController timeLimitPerSpareIntegralController;

  @override
  void initState() {
    title = widget.agendaItem.title;
    integralsCodes = widget.agendaItem.integralsCodes.join(',');
    spareIntegralsCodes = widget.agendaItem.spareIntegralsCodes.join(',');
    timeLimitPerIntegral =
        widget.agendaItem.timeLimitPerIntegral.inSeconds.toString();
    timeLimitPerSpareIntegral =
        widget.agendaItem.timeLimitPerSpareIntegral.inSeconds.toString();

    titleController = TextEditingController(text: title);
    integralsCodesController = TextEditingController(text: integralsCodes);
    spareIntegralsCodesController =
        TextEditingController(text: spareIntegralsCodes);
    timeLimitPerIntegralController =
        TextEditingController(text: timeLimitPerIntegral);
    timeLimitPerSpareIntegralController =
        TextEditingController(text: timeLimitPerSpareIntegral);

    super.initState();
  }

  @override
  void didUpdateWidget(covariant AgendaItemQualification oldWidget) {
    reset();

    super.didUpdateWidget(oldWidget);
  }

  void reset() {
    title = widget.agendaItem.title;
    integralsCodes = widget.agendaItem.integralsCodes.join(',');
    spareIntegralsCodes = widget.agendaItem.spareIntegralsCodes.join(',');
    timeLimitPerIntegral =
        widget.agendaItem.timeLimitPerIntegral.inSeconds.toString();
    timeLimitPerSpareIntegral =
        widget.agendaItem.timeLimitPerSpareIntegral.inSeconds.toString();

    titleController.text = title;
    integralsCodesController.text = integralsCodes;
    spareIntegralsCodesController.text = spareIntegralsCodes;
    timeLimitPerIntegralController.text = timeLimitPerIntegral;
    timeLimitPerSpareIntegralController.text = timeLimitPerSpareIntegral;

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
            // Column 1:
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: Text(
                          MyIntl.of(context).integralColon,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          enabled:
                              widget.agendaItem.phase != AgendaItemPhase.over,
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
                  Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: Text(
                          MyIntl.of(context).timeLimitColon,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          enabled:
                              widget.agendaItem.phase != AgendaItemPhase.over,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: MyIntl.of(context).durationInSeconds,
                          ),
                          controller: timeLimitPerIntegralController,
                          onChanged: (v) => setState(() {
                            timeLimitPerIntegral = v;
                            hasChanged = true;
                          }),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Column 2:
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 125,
                        child: Text(
                          MyIntl.of(context).spareIntegralsColon,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          enabled:
                              widget.agendaItem.phase != AgendaItemPhase.over,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: MyIntl.of(context).codesRequired,
                          ),
                          controller: spareIntegralsCodesController,
                          onChanged: (v) => setState(() {
                            spareIntegralsCodes = v;
                            hasChanged = true;
                          }),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 125,
                        child: Text(
                          MyIntl.of(context).timeLimitColon,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          enabled:
                              widget.agendaItem.phase != AgendaItemPhase.over,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: MyIntl.of(context).durationInSeconds,
                          ),
                          controller: timeLimitPerSpareIntegralController,
                          onChanged: (v) => setState(() {
                            timeLimitPerSpareIntegral = v;
                            hasChanged = true;
                          }),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
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
                  spareIntegralsCodes:
                      spareIntegralsCodes.split(',').deleteEmptyEntries(),
                  timeLimitPerIntegral:
                      Duration(seconds: int.parse(timeLimitPerIntegral)),
                  timeLimitPerSpareIntegral:
                      Duration(seconds: int.parse(timeLimitPerSpareIntegral)),
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
