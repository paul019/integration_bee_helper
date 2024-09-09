import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_test.dart';

class PresentationScreenTest extends StatelessWidget {
  final AgendaItemModelTest activeAgendaItem;
  final Size size;

  const PresentationScreenTest({
    super.key,
    required this.activeAgendaItem,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final p = size.width / 1920.0;

    return Padding(
      padding: EdgeInsets.all(50 * p),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            activeAgendaItem.title,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 100 * p),
          ),
        ],
      ),
    );
  }
}
