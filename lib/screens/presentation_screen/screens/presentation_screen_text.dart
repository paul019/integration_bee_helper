import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_text.dart';

class PresentationScreenText extends StatelessWidget {
  final AgendaItemModelText activeAgendaItem;
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
        padding: EdgeInsets.all(75 * p),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 75 * p),
              child: Image(
                image: NetworkImage(activeAgendaItem.imageUrl!),
                width: 500 * p,
                height: (1080 - 2 * 75) * p,
                fit: BoxFit.contain,
              ),
            ),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activeAgendaItem.title,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 100 * p),
                  ),
                  Text(
                    activeAgendaItem.subtitle,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 60 * p),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else if (activeAgendaItem.hasImage) {
      return Padding(
        padding: EdgeInsets.all(75 * p),
        child: Image(
          image: NetworkImage(activeAgendaItem.imageUrl!),
          width: 1000 * p,
          height: 750 * p,
          fit: BoxFit.contain,
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
              activeAgendaItem.subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 60 * p),
            ),
          ],
        ),
      );
    }
  }
}
