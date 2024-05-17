import 'package:flutter/material.dart';
import 'package:integration_bee_helper/extensions/exception_extension.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_model.dart';
import 'package:integration_bee_helper/services/agenda_items_service/agenda_items_service.dart';
import 'package:integration_bee_helper/widgets/confirmation_dialog.dart';

class NavigationCard extends StatelessWidget {
  final AgendaItemModel? activeAgendaItem;

  const NavigationCard({super.key, required this.activeAgendaItem});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              IconButton(
                onPressed: activeAgendaItem?.orderIndex != null &&
                        activeAgendaItem?.orderIndex != 0
                    ? () {
                        ConfirmationDialog(
                          title: 'Do you really want to go back?',
                          payload: () {
                            try {
                              AgendaItemsService().goBack(activeAgendaItem!);
                            } on Exception catch (e) {
                              e.show(context);
                            }
                          },
                        ).launch(context);
                      }
                    : null,
                icon: const Icon(Icons.arrow_back),
              ),
              Flexible(
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        activeAgendaItem?.displayTitle ??
                            'No active agenda item',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        maxLines: 1,
                      ),
                      Text(
                        activeAgendaItem?.displaySubtitle ??
                            'Please choose an agenda item in competition planner.',
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: activeAgendaItem?.orderIndex != null
                    ? () {
                        ConfirmationDialog(
                          bypassConfirmation: activeAgendaItem!.finished,
                          title:
                              'The current agenda item is not finished yet. Do you want to go forward anyway?',
                          payload: () {
                            try {
                              AgendaItemsService().goForward(activeAgendaItem!);
                            } on Exception catch (e) {
                              e.show(context);
                            }
                          },
                        ).launch(context);
                      }
                    : null,
                icon: const Icon(Icons.arrow_forward),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
