import 'package:flutter/material.dart';
import 'package:integration_bee_helper/extensions/exception_extension.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_knockout.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_model.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_not_specified.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_phase.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_qualification.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_text.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_type.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_video.dart';
import 'package:integration_bee_helper/screens/competition_planner_page/agenda_item_card/agenda_item_knockout.dart';
import 'package:integration_bee_helper/screens/competition_planner_page/agenda_item_card/agenda_item_not_specified.dart';
import 'package:integration_bee_helper/screens/competition_planner_page/agenda_item_card/agenda_item_qualification.dart';
import 'package:integration_bee_helper/screens/competition_planner_page/agenda_item_card/agenda_item_text.dart';
import 'package:integration_bee_helper/screens/competition_planner_page/agenda_item_card/agenda_item_video.dart';
import 'package:integration_bee_helper/services/agenda_items_service/agenda_items_service.dart';
import 'package:integration_bee_helper/widgets/confirmation_dialog.dart';
import 'package:integration_bee_helper/widgets/text_bubble.dart';
import 'package:provider/provider.dart';

class AgendaItemCard extends StatelessWidget {
  final AgendaItemModel agendaItem;
  final AgendaItemModel? activeAgendaItem;

  const AgendaItemCard({
    super.key,
    required this.agendaItem,
    required this.activeAgendaItem,
  });

  @override
  Widget build(BuildContext context) {
    final agendaItems = Provider.of<List<AgendaItemModel>?>(context)!;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Opacity(
        opacity: agendaItem.phase == AgendaItemPhase.over ? 0.6 : 1,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Column(
                      children: [
                        TextBubble(
                          color: agendaItem.currentlyActive
                              ? Theme.of(context).colorScheme.inversePrimary
                              : null,
                          text: 'Agenda item #${agendaItem.orderIndex + 1}',
                        ),
                        Text(
                          '(${agendaItem.type.title})',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: AgendaItemsService().canDeleteAgendaItem(
                            agendaItem,
                            currentAgendaItems: agendaItems,
                          )
                              ? () {
                                  ConfirmationDialog(
                                    bypassConfirmation: agendaItem.type ==
                                        AgendaItemType.notSpecified,
                                    title:
                                        'Do you really want to delete this agenda item?',
                                    payload: () async {
                                      try {
                                        await AgendaItemsService()
                                            .deleteAgendaItem(
                                          agendaItem,
                                          currentAgendaItems: agendaItems,
                                        );
                                      } on Exception catch (e) {
                                        if (context.mounted) e.show(context);
                                      }
                                    },
                                  ).launch(context);
                                }
                              : null,
                          icon: const Icon(Icons.delete),
                        ),
                        IconButton(
                            onPressed: () {
                              ConfirmationDialog(
                                title:
                                    'Do you really want to force-start this agenda item?',
                                payload: () => AgendaItemsService()
                                    .forceStartAgendaItem(agendaItem),
                                bypassConfirmation: activeAgendaItem == null,
                              ).launch(context);
                            },
                            icon: const Icon(Icons.play_arrow)),
                        Flexible(child: Container()),
                        IconButton(
                          onPressed: AgendaItemsService().canRaiseAgendaItem(
                            agendaItem,
                            currentAgendaItems: agendaItems,
                          )
                              ? () async {
                                  try {
                                    await AgendaItemsService().raiseAgendaItem(
                                      agendaItem,
                                      currentAgendaItems: agendaItems,
                                    );
                                  } on Exception catch (e) {
                                    if (context.mounted) e.show(context);
                                  }
                                }
                              : null,
                          icon: const Icon(Icons.arrow_upward),
                        ),
                        IconButton(
                          onPressed: AgendaItemsService().canLowerAgendaItem(
                            agendaItem,
                            currentAgendaItems: agendaItems,
                          )
                              ? () async {
                                  try {
                                    await AgendaItemsService().lowerAgendaItem(
                                      agendaItem,
                                      currentAgendaItems: agendaItems,
                                    );
                                  } on Exception catch (e) {
                                    if (context.mounted) e.show(context);
                                  }
                                }
                              : null,
                          icon: const Icon(Icons.arrow_downward),
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(),
                if (agendaItem.type == AgendaItemType.notSpecified)
                  AgendaItemNotSpecified(
                    agendaItem: agendaItem as AgendaItemModelNotSpecified,
                  ),
                if (agendaItem.type == AgendaItemType.text)
                  AgendaItemText(
                    agendaItem: agendaItem as AgendaItemModelText,
                  ),
                if (agendaItem.type == AgendaItemType.knockout)
                  AgendaItemKnockout(
                    agendaItem: agendaItem as AgendaItemModelKnockout,
                  ),
                if (agendaItem.type == AgendaItemType.qualification)
                  AgendaItemQualification(
                    agendaItem: agendaItem as AgendaItemModelQualification,
                  ),
                if (agendaItem.type == AgendaItemType.video)
                  AgendaItemVideo(
                    agendaItem: agendaItem as AgendaItemModelVideo,
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
