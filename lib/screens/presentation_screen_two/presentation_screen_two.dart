import 'package:flutter/material.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_competition.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_model.dart';
import 'package:integration_bee_helper/models/settings_model/settings_model.dart';
import 'package:integration_bee_helper/screens/presentation_screen/background_view.dart';
import 'package:integration_bee_helper/screens/presentation_screen/copyright_view.dart';
import 'package:integration_bee_helper/screens/presentation_screen/logo_view.dart';
import 'package:integration_bee_helper/screens/presentation_screen_two/tournament_tree_view.dart';
import 'package:integration_bee_helper/widgets/current_integral_stream.dart';
import 'package:integration_bee_helper/widgets/youtube_view.dart';

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
        LogoView(
          size: widget.size,
          transitionMode: false,
        ),
        CopyrightView(size: widget.size),
        _buildContent(),
      ],
    );
  }

  Widget _buildTournamentTree() {
    if (widget.settings == null) return Container();

    return TournamentTreeView(
      tournamentTreeModel: widget.settings!.tournamentTree,
      size: widget.size,
    );
  }

  Widget _buildContent() {
    if (widget.activeAgendaItem is AgendaItemModelCompetition) {
      final AgendaItemModelCompetition agendaItem =
          widget.activeAgendaItem as AgendaItemModelCompetition;

      return CurrentIntegralStream(
        integralCode: agendaItem.currentIntegralCode,
        builder: (context, currentIntegral) {
          final youtubeVideoId = currentIntegral?.youtubeVideoId ?? '';

          if (youtubeVideoId != '') {
            return YoutubeView(
              size: widget.size,
              videoId: youtubeVideoId,
            );
          } else {
            return _buildTournamentTree();
          }
        },
      );
    } else {
      return _buildTournamentTree();
    }
  }
}