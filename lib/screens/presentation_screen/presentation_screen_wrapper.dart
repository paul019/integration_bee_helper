import 'dart:html';

import 'package:flutter/material.dart';
import 'package:integration_bee_helper/models/settings_model/settings_model.dart';
import 'package:integration_bee_helper/screens/presentation_screen/presentation_screen.dart';
import 'package:integration_bee_helper/screens/presentation_screen_two/presentation_screen_two.dart';
import 'package:integration_bee_helper/widgets/active_agenda_item_stream.dart';
import 'package:provider/provider.dart';

enum PresentationScreenType {
  one,
  two;

  PresentationScreenType switched(bool switched) {
    if (switched) {
      return this == one ? two : one;
    } else {
      return this;
    }
  }
}

class PresentationScreenWrapper extends StatefulWidget {
  final PresentationScreenType type;

  const PresentationScreenWrapper({super.key, required this.type});

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
          final settings = Provider.of<SettingsModel?>(context);
          final switched = settings?.screensSwitched ?? false;

          switch(widget.type.switched(switched)) {
            case PresentationScreenType.one:
              return PresentationScreen(
                activeAgendaItem: activeAgendaItem,
                size: MediaQuery.sizeOf(context),
              );
            case PresentationScreenType.two:
              return PresentationScreenTwo(
                activeAgendaItem: activeAgendaItem,
                settings: settings,
                size: MediaQuery.sizeOf(context),
              );
          }
        },
      ),
    );
  }
}
