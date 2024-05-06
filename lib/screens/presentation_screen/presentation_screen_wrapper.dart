import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_model.dart';
import 'package:integration_bee_helper/screens/presentation_screen/presentation_screen.dart';
import 'package:integration_bee_helper/services/agenda_items_service.dart';
import 'package:provider/provider.dart';

enum PresentationScreenEvents { timeUp }

class PresentationScreenWrapper extends StatefulWidget {
  const PresentationScreenWrapper({super.key});

  @override
  State<PresentationScreenWrapper> createState() =>
      _PresentationScreenWrapperState();
}

class _PresentationScreenWrapperState extends State<PresentationScreenWrapper> {
  var focusNode = FocusNode();
  var hasShownSnackbar = false;

  @override
  void initState() {
    document.documentElement?.requestFullscreen();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authModel = Provider.of<User?>(context)!;
    final service = AgendaItemsService(uid: authModel.uid);

    FocusScope.of(context).requestFocus(focusNode);

    if (!hasShownSnackbar) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Press q to exit presentation mode.'),
          ),
        ),
      );

      hasShownSnackbar = true;
    }

    return Scaffold(
      body: StreamProvider<List<AgendaItemModel>?>.value(
        initialData: null,
        value: service.onActiveAgendaItemChanged,
        builder: (context, snapshot) {
          final agendaItems = Provider.of<List<AgendaItemModel>?>(context);
          final activeAgendaItem = agendaItems == null
              ? null
              : agendaItems.isEmpty
                  ? null
                  : agendaItems[0];

          return RawKeyboardListener(
            focusNode: focusNode,
            onKey: (event) {
              if (event.character == 'q') {
                Navigator.of(context).pop();
              }
            },
            child: PresentationScreen(
              activeAgendaItem: activeAgendaItem,
              size: MediaQuery.of(context).size,
            ),
          );
        },
      ),
    );
  }
}
