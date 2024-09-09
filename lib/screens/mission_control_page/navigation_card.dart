import 'package:flutter/material.dart';
import 'package:integration_bee_helper/extensions/exception_extension.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_model.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_phase.dart';
import 'package:integration_bee_helper/services/agenda_items_service/agenda_items_service.dart';
import 'package:integration_bee_helper/services/basic_services/intl_service.dart';
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
                          title: MyIntl.S.doYouReallyWantToGoBack,
                          payload: () async {
                            try {
                              await AgendaItemsService()
                                  .goBack(activeAgendaItem!);
                            } on Exception catch (e) {
                              if (context.mounted) e.show(context);
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
                            MyIntl.S.noActiveAgendaItem,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        maxLines: 1,
                      ),
                      Text(
                        activeAgendaItem?.displaySubtitle ??
                            MyIntl
                                .S.pleaseChooseAnAgendaItemInCompetitionPlanner,
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
                          bypassConfirmation: activeAgendaItem!.phase ==
                              AgendaItemPhase.activeButFinished,
                          title: MyIntl.S.currentAgendaItemIsNotFinishedYet,
                          payload: () async {
                            try {
                              await AgendaItemsService()
                                  .goForward(activeAgendaItem!);
                            } on Exception catch (e) {
                              if (context.mounted) e.show(context);
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
