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
  var focusNode = FocusNode();
  var hasShownSnackbar = false;

  @override
  void initState() {
    document.documentElement?.requestFullscreen();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
      body: ActiveAgendaItemStream(
        builder: (context, activeAgendaItem) {
          return RawKeyboardListener(
            focusNode: focusNode,
            onKey: (event) {
              if (event.character == 'q') {
                Navigator.of(context).pop();
              }
            },
            child: PresentationScreen(
              activeAgendaItem: activeAgendaItem,
              size: MediaQuery.sizeOf(context),
            ),
          );
        },
      ),
    );
  }
}
