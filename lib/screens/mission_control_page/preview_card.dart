import 'package:flutter/material.dart';
import 'package:integration_bee_helper/models/agenda_item_model.dart';
import 'package:integration_bee_helper/screens/presentation_screen/presentation_screen.dart';

class PreviewCard extends StatelessWidget {
  final AgendaItemModel? activeAgendaItem;

  const PreviewCard({super.key, required this.activeAgendaItem});

  @override
  Widget build(BuildContext context) {
    const double width = 850 - 4 * 8;
    const double height = width / 1920 * 1080;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: PresentationScreen(
            activeAgendaItem: activeAgendaItem,
            size: const Size(width, height),
          ),
        ),
      ),
    );
  }
}
