import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:integration_bee_helper/models/agenda_item_model.dart';
import 'package:integration_bee_helper/services/agenda_items_service.dart';
import 'package:integration_bee_helper/widgets/cancel_save_buttons.dart';

class AgendaItemKnockout extends StatefulWidget {
  final AgendaItemModel agendaItem;
  final AgendaItemsService service;

  const AgendaItemKnockout({
    super.key,
    required this.agendaItem,
    required this.service,
  });

  @override
  State<AgendaItemKnockout> createState() => _AgendaItemKnockoutState();
}

class _AgendaItemKnockoutState extends State<AgendaItemKnockout> {
  bool hasChanged = false;

  late String integralsCodes;
  late String spareIntegralsCodes;
  late String competitor1Name;
  late String competitor2Name;
  late String timeLimitPerIntegral;
  late String timeLimitPerSpareIntegral;

  late TextEditingController integralsCodesController;
  late TextEditingController spareIntegralsCodesController;
  late TextEditingController competitor1NameController;
  late TextEditingController competitor2NameController;
  late TextEditingController timeLimitPerIntegralController;
  late TextEditingController timeLimitPerSpareIntegralController;

  @override
  void initState() {
    integralsCodes = widget.agendaItem.integralsCodes!.join(',');
    spareIntegralsCodes = widget.agendaItem.spareIntegralsCodes!.join(',');
    competitor1Name = widget.agendaItem.competitor1Name!;
    competitor2Name = widget.agendaItem.competitor2Name!;
    timeLimitPerIntegral =
        widget.agendaItem.timeLimitPerIntegral!.inSeconds.toString();
    timeLimitPerSpareIntegral =
        widget.agendaItem.timeLimitPerSpareIntegral!.inSeconds.toString();

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
    integralsCodes = widget.agendaItem.integralsCodes!.join(',');
    spareIntegralsCodes = widget.agendaItem.spareIntegralsCodes!.join(',');
    competitor1Name = widget.agendaItem.competitor1Name!;
    competitor2Name = widget.agendaItem.competitor2Name!;
    timeLimitPerIntegral =
        widget.agendaItem.timeLimitPerIntegral!.inSeconds.toString();
    timeLimitPerSpareIntegral =
        widget.agendaItem.timeLimitPerSpareIntegral!.inSeconds.toString();

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
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Competitor 1',
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
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Competitor 2',
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
                      const SizedBox(
                        width: 100,
                        child: Text(
                          'Integrals:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Codes',
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
                      const SizedBox(
                        width: 100,
                        child: Text(
                          'Time limit:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Duration in seconds',
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
                      const SizedBox(
                        width: 125,
                        child: Text(
                          'Spare Integrals:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Codes',
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
                      const SizedBox(
                        width: 125,
                        child: Text(
                          'Time limit:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Duration in seconds',
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
              await widget.service.editAgendaItemKnockout(
                widget.agendaItem.id!,
                integralsCodes: integralsCodes,
                spareIntegralsCodes: spareIntegralsCodes,
                competitor1Name: competitor1Name,
                competitor2Name: competitor2Name,
                timeLimitPerIntegral:
                    Duration(seconds: int.parse(timeLimitPerIntegral)),
                timeLimitPerSpareIntegral:
                    Duration(seconds: int.parse(timeLimitPerSpareIntegral)),
              );
              setState(() => hasChanged = false);
            },
          ),
      ],
    );
  }
}
