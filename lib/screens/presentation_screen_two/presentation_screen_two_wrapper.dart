import 'dart:html';

import 'package:flutter/material.dart';
import 'package:integration_bee_helper/models/settings_model/settings_model.dart';
import 'package:integration_bee_helper/screens/presentation_screen_two/presentation_screen_two.dart';
import 'package:integration_bee_helper/services/settings_service/settings_service.dart';
import 'package:integration_bee_helper/widgets/active_agenda_item_stream.dart';
import 'package:provider/provider.dart';

enum PresentationScreenEvents { timeUp }

class PresentationScreenTwoWrapper extends StatefulWidget {
  const PresentationScreenTwoWrapper({super.key});

  @override
  State<PresentationScreenTwoWrapper> createState() =>
      _PresentationScreenTwoWrapperState();
}

class _PresentationScreenTwoWrapperState
    extends State<PresentationScreenTwoWrapper> {
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
          return StreamProvider<SettingsModel?>.value(
              initialData: null,
              value: SettingsService().onSettingsChanged,
              builder: (context, snapshot) {
                final settings = Provider.of<SettingsModel?>(context);

                return RawKeyboardListener(
                  focusNode: focusNode,
                  onKey: (event) {
                    if (event.character == 'q') {
                      Navigator.of(context).pop();
                    }
                  },
                  child: PresentationScreenTwo(
                    activeAgendaItem: activeAgendaItem,
                    settings: settings,
                    size: MediaQuery.sizeOf(context),
                  ),
                );
              });
        },
      ),
    );
  }
}
