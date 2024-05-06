import 'package:flutter/material.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_model.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_type.dart';
import 'package:integration_bee_helper/services/agenda_items_service.dart';

class AgendaItemNotSpecified extends StatelessWidget {
  final AgendaItemModel agendaItem;
  final AgendaItemsService service;

  const AgendaItemNotSpecified({
    super.key,
    required this.agendaItem,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (var type in AgendaItemType.selectable)
          SizedBox(
            width: 150,
            height: 150,
            child: InkWell(
              onTap: () {
                service.setAgendaItemType(agendaItem, type);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(25),
                      ),
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                    alignment: Alignment.center,
                    child: Icon(type.icon),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      type.title,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
