import 'package:flutter/material.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_model.dart';
import 'package:integration_bee_helper/models/settings_model/settings_model.dart';
import 'package:integration_bee_helper/screens/presentation_screen/background_view.dart';
import 'package:integration_bee_helper/screens/presentation_screen/copyright_view.dart';
import 'package:integration_bee_helper/screens/presentation_screen/logo_view.dart';
import 'package:integration_bee_helper/screens/presentation_screen_two/tournament_tree_view.dart';

class PresentationScreenTwo extends StatefulWidget {
  final AgendaItemModel? activeAgendaItem;
  final SettingsModel? settings;
  final Size size;

  const PresentationScreenTwo({
    super.key,
    required this.activeAgendaItem,
    required this.settings,
    required this.size,
  });

  @override
  State<PresentationScreenTwo> createState() => _PresentationScreenTwoState();
}

class _PresentationScreenTwoState extends State<PresentationScreenTwo> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        BackgroundView(size: widget.size),
        if (widget.settings != null)
          TournamentTreeView(
            tournamentTreeModel: widget.settings!.tournamentTree,
            size: widget.size,
          ),
        LogoView(
          size: widget.size,
          transitionMode: false,
        ),
        CopyrightView(size: widget.size),
      ],
    );
  }
}
