import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:integration_bee_helper/models/agenda_item_model.dart';
import 'package:integration_bee_helper/screens/presentation_screen/presentation_screen.dart';
import 'package:integration_bee_helper/services/agenda_items_service.dart';
import 'package:provider/provider.dart';

class PresentationScreenWrapper extends StatefulWidget {
  const PresentationScreenWrapper({super.key});

  @override
  State<PresentationScreenWrapper> createState() =>
      _PresentationScreenWrapperState();
}

class _PresentationScreenWrapperState extends State<PresentationScreenWrapper> {
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
          final activeAgendaItem = agendaItems == null
              ? null
              : agendaItems.isEmpty
                  ? null
                  : agendaItems[0];

          return PresentationScreen(
            activeAgendaItem: activeAgendaItem,
            size: MediaQuery.of(context).size,
          );
        },
      ),
    );
  }
}
