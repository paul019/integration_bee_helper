import 'package:flutter/material.dart';
import 'package:integration_bee_helper/models/agenda_item_model.dart';
import 'package:integration_bee_helper/screens/competition_planner_page/agenda_item_card/agenda_item_not_specified.dart';
import 'package:integration_bee_helper/services/agenda_items_service.dart';
import 'package:integration_bee_helper/widgets/confirmation_dialog.dart';
import 'package:provider/provider.dart';

class AgendaItemCard extends StatelessWidget {
  final AgendaItemModel agendaItem;
  final AgendaItemsService service;

  const AgendaItemCard({
    super.key,
    required this.agendaItem,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    final agendaItems = Provider.of<List<AgendaItemModel>?>(context)!;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Text(
                    'Agenda item #${agendaItem.orderIndex + 1}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (agendaItem.type == AgendaItemType.notSpecified) {
                            service.deleteAgendaItem(
                              agendaItem,
                              currentAgendaItems: agendaItems,
                            );
                            return;
                          }

                          ConfirmationDialog(
                            title:
                                'Do you really want to delete this agenda item?',
                            payload: () => service.deleteAgendaItem(
                              agendaItem,
                              currentAgendaItems: agendaItems,
                            ),
                          ).launch(context);
                        },
                        icon: const Icon(Icons.delete),
                      ),
                      Flexible(child: Container()),
                      IconButton(
                        onPressed: () {
                          service.raiseAgendaItem(
                            agendaItem,
                            currentAgendaItems: agendaItems,
                          );
                        },
                        icon: const Icon(Icons.arrow_upward),
                      ),
                      IconButton(
                        onPressed: () {
                          service.lowerAgendaItem(
                            agendaItem,
                            currentAgendaItems: agendaItems,
                          );
                        },
                        icon: const Icon(Icons.arrow_downward),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(),
              if (agendaItem.type == AgendaItemType.notSpecified)
                const AgendaItemNotSpecified(),
            ],
          ),
        ),
      ),
    );
  }
}
