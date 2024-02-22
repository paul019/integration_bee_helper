import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:integration_bee_helper/models/agenda_item_model.dart';
import 'package:integration_bee_helper/screens/presentation_screen/background_view.dart';
import 'package:integration_bee_helper/screens/presentation_screen/presentation_screen_knockout.dart';
import 'package:integration_bee_helper/screens/presentation_screen/presentation_screen_text.dart';
import 'package:integration_bee_helper/services/agenda_items_service.dart';
import 'package:provider/provider.dart';

class PresentationScreen extends StatefulWidget {
  const PresentationScreen({super.key});

  @override
  State<PresentationScreen> createState() => _PresentationScreenState();
}

class _PresentationScreenState extends State<PresentationScreen> {
  @override
  void initState() {
    document.documentElement?.requestFullscreen();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authModel = Provider.of<User?>(context)!;
    final service = AgendaItemsService(uid: authModel.uid);

    return Scaffold(
      body: StreamProvider<List<AgendaItemModel>?>.value(
        initialData: null,
        value: service.onAgendaItemsChanged,
        builder: (context, snapshot) {
          final agendaItems = Provider.of<List<AgendaItemModel>?>(context);

          if (agendaItems == null || agendaItems.isEmpty) {
            return const BackgroundView();
          }

          final activeAgendaItem = agendaItems[0];

          switch (activeAgendaItem.type) {
            case AgendaItemType.notSpecified:
              return const BackgroundView();
            case AgendaItemType.text:
              return PresentationScreenText(
                activeAgendaItem: activeAgendaItem,
              );
            case AgendaItemType.knockout:
              return PresentationScreenKnockout(
                activeAgendaItem: activeAgendaItem,
              );
          }
        },
      ),
    );
  }
}
