import 'package:flutter/material.dart';
import 'package:integration_bee_helper/models/agenda_item_model.dart';

class KnockoutControlElements extends StatelessWidget {
  final AgendaItemModel activeAgendaItem;

  const KnockoutControlElements({super.key, required this.activeAgendaItem});

  @override
  Widget build(BuildContext context) {
    switch (activeAgendaItem.phaseIndex!) {
      case 0:
        return TextButton(
          onPressed: () {},
          child: const Text('Start!'),
        );
      default:
        return Container();
    }
  }
}
