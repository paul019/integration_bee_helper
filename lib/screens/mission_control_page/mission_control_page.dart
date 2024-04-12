import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:integration_bee_helper/models/agenda_item_model.dart';
import 'package:integration_bee_helper/screens/mission_control_page/control_card.dart';
import 'package:integration_bee_helper/screens/mission_control_page/navigation_card.dart';
import 'package:integration_bee_helper/screens/mission_control_page/preview_card.dart';
import 'package:integration_bee_helper/services/agenda_items_service.dart';
import 'package:integration_bee_helper/widgets/max_width_wrapper.dart';
import 'package:provider/provider.dart';

class MissionControlPage extends StatelessWidget {
  const MissionControlPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authModel = Provider.of<User?>(context)!;
    final service = AgendaItemsService(uid: authModel.uid);

    return StreamProvider<List<AgendaItemModel>?>.value(
      initialData: null,
      value: service.onActiveAgendaItemChanged,
      builder: (context, snapshot) {
        final agendaItems = Provider.of<List<AgendaItemModel>?>(context);
        final activeAgendaItem = agendaItems == null
            ? null
            : agendaItems.isEmpty
                ? null
                : agendaItems[0];

        return MaxWidthWrapper(
          child: Column(
            children: [
              NavigationCard(activeAgendaItem: activeAgendaItem),
              PreviewCard(activeAgendaItem: activeAgendaItem),
              ControlCard(activeAgendaItem: activeAgendaItem),
            ],
          ),
        );
      },
    );
  }
}
