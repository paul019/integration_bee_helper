import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:integration_bee_helper/models/agenda_item_model.dart';
import 'package:integration_bee_helper/services/agenda_items_service.dart';
import 'package:integration_bee_helper/widgets/confirmation_dialog.dart';
import 'package:provider/provider.dart';

class NavigationCard extends StatelessWidget {
  final AgendaItemModel? activeAgendaItem;

  const NavigationCard({super.key, required this.activeAgendaItem});

  @override
  Widget build(BuildContext context) {
    final authModel = Provider.of<User?>(context)!;
    final service = AgendaItemsService(uid: authModel.uid);

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
                          payload: () => service.goBack(activeAgendaItem!),
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
                        activeAgendaItem?.displaySubtitle ?? '',
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: activeAgendaItem?.orderIndex != null
                    ? () {
                        if (activeAgendaItem!.finished) {
                          service.goForward(activeAgendaItem!);
                          return;
                        }

                        ConfirmationDialog(
                          title:
                              'The current agenda item is not finished yet. Do you want to go forward anyway?',
                          payload: () => service.goForward(activeAgendaItem!),
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
