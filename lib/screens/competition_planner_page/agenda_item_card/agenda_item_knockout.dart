import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:integration_bee_helper/extensions/exception_extension.dart';
import 'package:integration_bee_helper/extensions/list_extension.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_knockout.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_phase.dart';
import 'package:integration_bee_helper/services/basic_services/intl_service.dart';
import 'package:integration_bee_helper/widgets/cancel_save_buttons.dart';

class AgendaItemKnockout extends StatefulWidget {
  final AgendaItemModelKnockout agendaItem;

  const AgendaItemKnockout({
    super.key,
    required this.agendaItem,
  });

  @override
  State<AgendaItemKnockout> createState() => _AgendaItemKnockoutState();
}

class _AgendaItemKnockoutState extends State<AgendaItemKnockout> {
  bool hasChanged = false;

  late String title;
  late String integralsCodes;
  late String spareIntegralsCodes;
  late String competitor1Name;
  late String competitor2Name;
  late String timeLimitPerIntegral;
  late String timeLimitPerSpareIntegral;

  late TextEditingController titleController;
  late TextEditingController integralsCodesController;
  late TextEditingController spareIntegralsCodesController;
  late TextEditingController competitor1NameController;
  late TextEditingController competitor2NameController;
  late TextEditingController timeLimitPerIntegralController;
  late TextEditingController timeLimitPerSpareIntegralController;

  @override
  void initState() {
    title = widget.agendaItem.title;
    integralsCodes = widget.agendaItem.integralsCodes.join(',');
    spareIntegralsCodes = widget.agendaItem.spareIntegralsCodes.join(',');
    competitor1Name = widget.agendaItem.competitor1Name;
    competitor2Name = widget.agendaItem.competitor2Name;
    timeLimitPerIntegral =
        widget.agendaItem.timeLimitPerIntegral.inSeconds.toString();
    timeLimitPerSpareIntegral =
        widget.agendaItem.timeLimitPerSpareIntegral.inSeconds.toString();

    titleController = TextEditingController(text: title);
    integralsCodesController = TextEditingController(text: integralsCodes);
    spareIntegralsCodesController =
        TextEditingController(text: spareIntegralsCodes);
    competitor1NameController = TextEditingController(text: competitor1Name);
    competitor2NameController = TextEditingController(text: competitor2Name);
    timeLimitPerIntegralController =
        TextEditingController(text: timeLimitPerIntegral);
    timeLimitPerSpareIntegralController =
        TextEditingController(text: timeLimitPerSpareIntegral);

    super.initState();
  }

  @override
  void didUpdateWidget(covariant AgendaItemKnockout oldWidget) {
    reset();

    super.didUpdateWidget(oldWidget);
  }

  void reset() {
    title = widget.agendaItem.title;
    integralsCodes = widget.agendaItem.integralsCodes.join(',');
    spareIntegralsCodes = widget.agendaItem.spareIntegralsCodes.join(',');
    competitor1Name = widget.agendaItem.competitor1Name;
    competitor2Name = widget.agendaItem.competitor2Name;
    timeLimitPerIntegral =
        widget.agendaItem.timeLimitPerIntegral.inSeconds.toString();
    timeLimitPerSpareIntegral =
        widget.agendaItem.timeLimitPerSpareIntegral.inSeconds.toString();

    titleController.text = title;
    integralsCodesController.text = integralsCodes;
    spareIntegralsCodesController.text = spareIntegralsCodes;
    competitor1NameController.text = competitor1Name;
    competitor2NameController.text = competitor2Name;
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
            Expanded(
              child: TextField(
                enabled: widget.agendaItem.phase != AgendaItemPhase.over,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: MyIntl.of(context).competitor1,
                ),
                controller: competitor1NameController,
                onChanged: (v) => setState(() {
                  competitor1Name = v;
                  hasChanged = true;
                }),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 50),
            const Text(
              'vs.',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 50),
            Expanded(
              child: TextField(
                enabled: widget.agendaItem.phase != AgendaItemPhase.over,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: MyIntl.of(context).competitor2,
                ),
                controller: competitor2NameController,
                onChanged: (v) => setState(() {
                  competitor2Name = v;
                  hasChanged = true;
                }),
                textAlign: TextAlign.center,
              ),
            )
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
                          MyIntl.of(context).integralsColon,
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
                            hintText: MyIntl.of(context).codesOptional,
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
                  competitor1Name: competitor1Name,
                  competitor2Name: competitor2Name,
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
