import 'package:flutter/material.dart';
import 'package:integration_bee_helper/models/agenda_item_model/active_agenda_item_wrapper.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_model.dart';
import 'package:integration_bee_helper/services/agenda_items_service/agenda_items_service.dart';
import 'package:provider/provider.dart';

class ActiveAgendaItemStream extends StatelessWidget {
  final Widget Function(BuildContext, AgendaItemModel?) builder;

  const ActiveAgendaItemStream({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return StreamProvider<ActiveAgendaItemWrapper>.value(
      initialData: ActiveAgendaItemWrapper(null),
      value: AgendaItemsService().onActiveAgendaItemChanged,
      builder: (context, snapshot) {
        final agendaItemWrapper = Provider.of<ActiveAgendaItemWrapper>(context);
        final activeAgendaItem = agendaItemWrapper.agendaItem;

        return builder(context, activeAgendaItem);
      },
    );
  }
}
