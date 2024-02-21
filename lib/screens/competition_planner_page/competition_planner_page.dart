import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:integration_bee_helper/models/agenda_item_model.dart';
import 'package:integration_bee_helper/screens/competition_planner_page/agenda_item_card/agenda_item_card.dart';
import 'package:integration_bee_helper/services/agenda_items_service.dart';
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
    final authModel = Provider.of<User?>(context)!;
    final service = AgendaItemsService(uid: authModel.uid);

    return StreamProvider<List<AgendaItemModel>?>.value(
        initialData: null,
        value: service.onAgendaItemsChanged,
        builder: (context, snapshot) {
          final agendaItems = Provider.of<List<AgendaItemModel>?>(context);

          if (agendaItems == null) {
            return const LoadingScreen();
          }

          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () =>
                  service.addAgendaItem(currentAgendaItems: agendaItems),
              child: const Icon(Icons.add),
            ),
            body: ListView.builder(
              itemCount: agendaItems.length,
              itemBuilder: (context, index) {
                final agendaItem = agendaItems[index];

                return MaxWidthWrapper(
                  child: AgendaItemCard(
                    agendaItem: agendaItem,
                    service: service,
                  ),
                );
              },
            ),
          );
        });
  }
}