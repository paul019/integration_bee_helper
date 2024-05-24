import 'dart:html';

import 'package:flutter/material.dart';
import 'package:integration_bee_helper/screens/presentation_screen/presentation_screen.dart';
import 'package:integration_bee_helper/widgets/active_agenda_item_stream.dart';

enum PresentationScreenEvents { timeUp }

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
    return Scaffold(
      body: ActiveAgendaItemStream(
        builder: (context, activeAgendaItem) {
          return PresentationScreen(
            activeAgendaItem: activeAgendaItem,
            size: MediaQuery.sizeOf(context),
          );
        },
      ),
    );
  }
}
