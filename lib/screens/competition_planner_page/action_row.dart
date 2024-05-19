import 'package:flutter/material.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_model.dart';
import 'package:integration_bee_helper/services/agenda_items_service/agenda_items_service.dart';
import 'package:integration_bee_helper/services/basic_services/export_documents_service.dart';
import 'package:integration_bee_helper/widgets/confirmation_dialog.dart';
import 'package:integration_bee_helper/widgets/text_button_with_icon.dart';
import 'package:integration_bee_helper/widgets/vertical_separator.dart';

class ActionRow extends StatelessWidget {
  final List<AgendaItemModel> agendaItems;

  const ActionRow({super.key, required this.agendaItems});

  void startFromBeginning(BuildContext context) {
    ConfirmationDialog(
      bypassConfirmation: agendaItems.every((item) => !item.currentlyActive),
      title: 'Do you really want to start from the beginning?',
      payload: () {
        AgendaItemsService()
            .startFromBeginning(currentAgendaItems: agendaItems);
      },
    ).launch(context);
  }

  void reset(BuildContext context) {
    ConfirmationDialog(
      bypassConfirmation: agendaItems.every((item) => !item.currentlyActive),
      title: 'Do you really want to reset?',
      payload: () {
        AgendaItemsService()
            .resetAllAgendaItems(currentAgendaItems: agendaItems);
      },
    ).launch(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButtonWithIcon(
              onPressed: () => startFromBeginning(context),
              icon: Icons.play_arrow,
              child: const Text('Start from beginning'),
            ),
            const VerticalSeparator(),
            TextButtonWithIcon(
              onPressed: () => reset(context),
              icon: Icons.refresh,
              child: const Text('Reset'),
            ),
            const VerticalSeparator(),
            TextButtonWithIcon(
              onPressed: () {
                ExportDocumentsService().exportDocuments(context);
              },
              icon: Icons.download,
              child: const Text('Download Documents'),
            ),
          ],
        ));
  }
}
