import 'package:flutter/material.dart';
import 'package:integration_bee_helper/models/agenda_item_model/active_agenda_item_wrapper.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_model.dart';
import 'package:integration_bee_helper/services/agenda_items_service/agenda_items_service.dart';
import 'package:integration_bee_helper/widgets/max_width_wrapper.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  AgendaItemModel? activeAgendaItem;

  @override
  Widget build(BuildContext context) {
    return StreamProvider<ActiveAgendaItemWrapper>.value(
      initialData: ActiveAgendaItemWrapper(null),
      value: AgendaItemsService().onActiveAgendaItemChanged,
      builder: (context, snapshot) {
        final agendaItemWrapper = Provider.of<ActiveAgendaItemWrapper>(context);

        return SingleChildScrollView(
          child: MaxWidthWrapper(
            child: Column(
              children: [],
            ),
          ),
        );
      },
    );
  }
}
