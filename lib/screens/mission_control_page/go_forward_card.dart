import 'package:flutter/material.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_model.dart';
import 'package:integration_bee_helper/services/agenda_items_service/agenda_items_service.dart';
import 'package:integration_bee_helper/services/basic_services/intl_service.dart';

class GoForwardCard extends StatefulWidget {
  final AgendaItemModel? activeAgendaItem;

  const GoForwardCard({super.key, required this.activeAgendaItem});

  @override
  State<GoForwardCard> createState() => _GoForwardCardState();
}

class _GoForwardCardState extends State<GoForwardCard> {
  int? _currentOrderIndex;
  AgendaItemModel? nextAgendaItem;

  @override
  Widget build(BuildContext context) {
    if (widget.activeAgendaItem?.phase.finished ?? false) {
      if (nextAgendaItem == null || _currentOrderIndex != widget.activeAgendaItem?.orderIndex) {
        _currentOrderIndex = widget.activeAgendaItem?.orderIndex;
        _fetchNextAgendaItem();
      }
    } else {
      nextAgendaItem = null;
    }

    if (nextAgendaItem == null) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12.0),
              onTap: () {
                AgendaItemsService().goForward(widget.activeAgendaItem!);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          MyIntl.of(context).comingUp.toUpperCase(),
                          style: const TextStyle(fontSize: 10),
                        ),
                        Text(
                          nextAgendaItem!.displayTitle(context),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 12.0),
                      child: Icon(Icons.arrow_forward),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _fetchNextAgendaItem() async {
    final currentIndex = widget.activeAgendaItem?.orderIndex;

    if (currentIndex == null) return;

    final nextAgendaItem = await AgendaItemsService()
        .getAgendaItemFromOrderIndex(currentIndex + 1);

    setState(() {
      this.nextAgendaItem = nextAgendaItem;
    });
  }
}
