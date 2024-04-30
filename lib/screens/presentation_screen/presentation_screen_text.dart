import 'package:flutter/material.dart';
import 'package:integration_bee_helper/models/agenda_item_model.dart';

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

    if (activeAgendaItem.hasTitle && activeAgendaItem.hasImage) {
      return Padding(
        padding: EdgeInsets.all(50 * p),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 50 * p),
              child: Image.network(
                activeAgendaItem.imageUrl!,
                width: 400 * p,
                height: 400 * p,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activeAgendaItem.title,
                  textAlign: TextAlign.left,
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 100 * p),
                ),
                Text(
                  activeAgendaItem.subtitle!,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 60 * p),
                ),
              ],
            ),
          ],
        ),
      );
    } else if (activeAgendaItem.hasImage) {
      return Padding(
        padding: EdgeInsets.all(50 * p),
        child: Image.network(
          activeAgendaItem.imageUrl!,
          width: 1000 * p,
          height: 750 * p,
        ),
      );
    } else {
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
            Text(
              activeAgendaItem.subtitle!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 60 * p),
            ),
          ],
        ),
      );
    }
  }
}
