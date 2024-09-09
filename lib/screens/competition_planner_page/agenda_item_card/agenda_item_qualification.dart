import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:integration_bee_helper/extensions/exception_extension.dart';
import 'package:integration_bee_helper/extensions/list_extension.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_phase.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_qualification.dart';
import 'package:integration_bee_helper/services/basic_services/intl_service.dart';
import 'package:integration_bee_helper/widgets/cancel_save_buttons.dart';

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
  late String competitorNames;
  late String integralsCodes;
  late String spareIntegralsCodes;
  late String timeLimitPerIntegral;
  late String timeLimitPerSpareIntegral;

  late TextEditingController titleController;
  late TextEditingController competitorNamesController;
  late TextEditingController integralsCodesController;
  late TextEditingController spareIntegralsCodesController;
  late TextEditingController timeLimitPerIntegralController;
  late TextEditingController timeLimitPerSpareIntegralController;

  @override
  void initState() {
    title = widget.agendaItem.title;
    competitorNames = widget.agendaItem.competitorNames.join(',');
    integralsCodes = widget.agendaItem.integralsCodes.join(',');
    spareIntegralsCodes = widget.agendaItem.spareIntegralsCodes.join(',');
    timeLimitPerIntegral =
        widget.agendaItem.timeLimitPerIntegral.inSeconds.toString();
    timeLimitPerSpareIntegral =
        widget.agendaItem.timeLimitPerSpareIntegral.inSeconds.toString();

    titleController = TextEditingController(text: title);
    competitorNamesController = TextEditingController(text: competitorNames);
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
    competitorNames = widget.agendaItem.competitorNames.join(',');
    integralsCodes = widget.agendaItem.integralsCodes.join(',');
    spareIntegralsCodes = widget.agendaItem.spareIntegralsCodes.join(',');
    timeLimitPerIntegral =
        widget.agendaItem.timeLimitPerIntegral.inSeconds.toString();
    timeLimitPerSpareIntegral =
        widget.agendaItem.timeLimitPerSpareIntegral.inSeconds.toString();

    titleController.text = title;
    competitorNamesController.text = competitorNames;
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
            // Column 1:
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: Text(
                          MyIntl.S.integralColon,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          enabled:
                              widget.agendaItem.phase != AgendaItemPhase.over,
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
                  Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: Text(
                          MyIntl.S.timeLimitColon,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          enabled:
                              widget.agendaItem.phase != AgendaItemPhase.over,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: MyIntl.S.durationInSeconds,
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
                          MyIntl.S.spareIntegralsColon,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          enabled:
                              widget.agendaItem.phase != AgendaItemPhase.over,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: MyIntl.S.codesRequired,
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
                          MyIntl.S.timeLimitColon,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          enabled:
                              widget.agendaItem.phase != AgendaItemPhase.over,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: MyIntl.S.durationInSeconds,
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
                  competitorNames:
                      competitorNames.split(',').deleteEmptyEntries(),
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
