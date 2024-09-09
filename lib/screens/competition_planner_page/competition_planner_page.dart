import 'package:flutter/material.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_model.dart';
import 'package:integration_bee_helper/screens/competition_planner_page/action_row.dart';
import 'package:integration_bee_helper/screens/competition_planner_page/agenda_item_card/agenda_item_card.dart';
import 'package:integration_bee_helper/services/agenda_items_service/agenda_items_service.dart';
import 'package:integration_bee_helper/services/basic_services/intl_service.dart';
import 'package:integration_bee_helper/widgets/loading_screen.dart';
import 'package:integration_bee_helper/widgets/max_width_wrapper.dart';
import 'package:provider/provider.dart';

class CompetitionPlannerPage extends StatefulWidget {
  const CompetitionPlannerPage({super.key});

  @override
  State<CompetitionPlannerPage> createState() => _CompetitionPlannerPageState();
}

class _CompetitionPlannerPageState extends State<CompetitionPlannerPage> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<AgendaItemModel>?>.value(
        initialData: null,
        value: AgendaItemsService().onAgendaItemsChanged,
        builder: (context, snapshot) {
          final agendaItems = Provider.of<List<AgendaItemModel>?>(context);
          final activeAgendaItems =
              agendaItems?.where((item) => item.currentlyActive) ?? [];
          final activeAgendaItem =
              activeAgendaItems.isNotEmpty ? activeAgendaItems.first : null;

          if (agendaItems == null) {
            return const LoadingScreen();
          }

          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () => AgendaItemsService()
                  .addAgendaItem(currentAgendaItems: agendaItems),
              child: const Icon(Icons.add),
            ),
            body: agendaItems.isEmpty
                ? Center(child: Text(MyIntl.S.noAgendaItemsYet))
                : ListView.builder(
                    itemCount: agendaItems.length + 2,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return ActionRow(agendaItems: agendaItems);
                      } else if (index == agendaItems.length + 1) {
                        return const SizedBox(height: 100);
                      }

                      final agendaItem = agendaItems[index - 1];

                      return MaxWidthWrapper(
                        child: AgendaItemCard(
                          agendaItem: agendaItem,
                          activeAgendaItem: activeAgendaItem,
                        ),
                      );
                    },
                  ),
          );
        });
  }
}
