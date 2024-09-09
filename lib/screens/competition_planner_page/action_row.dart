import 'package:flutter/material.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_model.dart';
import 'package:integration_bee_helper/services/agenda_items_service/agenda_items_service.dart';
import 'package:integration_bee_helper/services/basic_services/intl_service.dart';
import 'package:integration_bee_helper/services/export_documents_service/export_documents_service.dart';
import 'package:integration_bee_helper/widgets/confirmation_dialog.dart';
import 'package:integration_bee_helper/widgets/text_button_with_icon.dart';
import 'package:integration_bee_helper/widgets/vertical_separator.dart';

class ActionRow extends StatelessWidget {
  final List<AgendaItemModel> agendaItems;

  const ActionRow({super.key, required this.agendaItems});

  void startFromBeginning(BuildContext context) {
    ConfirmationDialog(
      bypassConfirmation: agendaItems.every((item) => !item.currentlyActive),
      title: MyIntl.of(context).doYouReallyWantToStartFromTheBeginning,
      payload: () {
        AgendaItemsService()
            .startFromBeginning(currentAgendaItems: agendaItems);
      },
    ).launch(context);
  }

  void reset(BuildContext context) {
    ConfirmationDialog(
      bypassConfirmation: agendaItems.every((item) => !item.currentlyActive),
      title: MyIntl.of(context).doYouReallyWantToReset,
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
              child: Text(MyIntl.of(context).startFromBeginning),
            ),
            const VerticalSeparator(),
            TextButtonWithIcon(
              onPressed: () => reset(context),
              icon: Icons.refresh,
              child: Text(MyIntl.of(context).reset),
            ),
            const VerticalSeparator(),
            TextButtonWithIcon(
              onPressed: () {
                ExportDocumentsService().exportDocuments(context);
              },
              icon: Icons.download,
              child: Text(MyIntl.of(context).downloadDocuments),
            ),
          ],
        ));
  }
}
