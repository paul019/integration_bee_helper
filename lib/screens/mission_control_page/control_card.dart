import 'package:flutter/material.dart';
import 'package:integration_bee_helper/models/agenda_item_model.dart';
import 'package:integration_bee_helper/screens/mission_control_page/knockout_control_elements.dart';

class ControlCard extends StatelessWidget {
  final AgendaItemModel? activeAgendaItem;

  const ControlCard({super.key, required this.activeAgendaItem});

  @override
  Widget build(BuildContext context) {
    if (controlElements() == null) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: controlElements()!,
          ),
        ),
      ),
    );
  }

  Widget? controlElements() {
    switch (activeAgendaItem!.type) {
      case AgendaItemType.notSpecified:
        return null;
      case AgendaItemType.text:
        return null;
      case AgendaItemType.knockout:
        return KnockoutControlElements(activeAgendaItem: activeAgendaItem!);
    }
  }
}
