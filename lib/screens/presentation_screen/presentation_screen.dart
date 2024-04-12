import 'package:flutter/material.dart';
import 'package:integration_bee_helper/models/agenda_item_model.dart';
import 'package:integration_bee_helper/screens/presentation_screen/background_view.dart';
import 'package:integration_bee_helper/screens/presentation_screen/presentation_screen_knockout.dart';
import 'package:integration_bee_helper/screens/presentation_screen/presentation_screen_text.dart';

class PresentationScreen extends StatelessWidget {
  final AgendaItemModel? activeAgendaItem;
  final Size size;

  const PresentationScreen({
    super.key,
    required this.activeAgendaItem,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    if (activeAgendaItem == null) {
      return BackgroundView(size: size);
    }

    switch (activeAgendaItem!.type) {
      case AgendaItemType.notSpecified:
        return BackgroundView(size: size);
      case AgendaItemType.text:
        return PresentationScreenText(
          activeAgendaItem: activeAgendaItem!,
          size: size,
        );
      case AgendaItemType.knockout:
        return PresentationScreenKnockout(
          activeAgendaItem: activeAgendaItem!,
          size: size,
        );
    }
  }
}
