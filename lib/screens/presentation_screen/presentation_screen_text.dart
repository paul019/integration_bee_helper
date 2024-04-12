import 'package:flutter/material.dart';
import 'package:integration_bee_helper/models/agenda_item_model.dart';
import 'package:integration_bee_helper/screens/presentation_screen/background_view.dart';
import 'package:integration_bee_helper/screens/presentation_screen/logo_view.dart';

class PresentationScreenText extends StatelessWidget {
  final AgendaItemModel activeAgendaItem;
  final Size size;

  const PresentationScreenText({
    super.key,
    required this.activeAgendaItem,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final p = size.width / 1920.0;

    return Stack(
      alignment: Alignment.center,
      children: [
        BackgroundView(size: size),
        LogoView(size: size),
        Padding(
          padding: EdgeInsets.all(50 * p),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                activeAgendaItem.title!,
                style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 100 * p),
              ),
              Text(
                activeAgendaItem.subtitle!,
                style: TextStyle(fontSize: 60 * p),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
