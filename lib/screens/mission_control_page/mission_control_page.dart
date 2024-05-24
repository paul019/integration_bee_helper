import 'package:flutter/material.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_model.dart';
import 'package:integration_bee_helper/screens/mission_control_page/control_card.dart';
import 'package:integration_bee_helper/screens/mission_control_page/navigation_card.dart';
import 'package:integration_bee_helper/screens/mission_control_page/preview_card.dart';
import 'package:integration_bee_helper/widgets/active_agenda_item_stream.dart';
import 'package:integration_bee_helper/widgets/max_width_wrapper.dart';

class MissionControlPage extends StatefulWidget {
  const MissionControlPage({super.key});

  @override
  State<MissionControlPage> createState() => _MissionControlPageState();
}

class _MissionControlPageState extends State<MissionControlPage> {
  AgendaItemModel? activeAgendaItem;

  @override
  Widget build(BuildContext context) {
    return ActiveAgendaItemStream(
      builder: (context, newAgendaItem) {
        if (newAgendaItem != null) {
          activeAgendaItem = newAgendaItem;
        }

        return SingleChildScrollView(
          child: MaxWidthWrapper(
            child: Column(
              children: [
                NavigationCard(activeAgendaItem: activeAgendaItem),
                PreviewCard(activeAgendaItem: activeAgendaItem),
                ControlCard(activeAgendaItem: activeAgendaItem),
              ],
            ),
          ),
        );
      },
    );
  }
}
