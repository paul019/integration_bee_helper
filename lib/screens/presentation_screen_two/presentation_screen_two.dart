import 'package:flutter/material.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_live_competition.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_model.dart';
import 'package:integration_bee_helper/models/agenda_item_model/problem_phase.dart';
import 'package:integration_bee_helper/models/settings_model/settings_model.dart';
import 'package:integration_bee_helper/screens/presentation_screen/widgets/background_view.dart';
import 'package:integration_bee_helper/screens/presentation_screen/widgets/copyright_view.dart';
import 'package:integration_bee_helper/screens/presentation_screen/widgets/logo_view.dart';
import 'package:integration_bee_helper/screens/presentation_screen_two/widgets/tournament_tree_view.dart';
import 'package:integration_bee_helper/services/basic_services/intl_service.dart';
import 'package:integration_bee_helper/widgets/current_integral_stream.dart';
import 'package:integration_bee_helper/widgets/youtube_view.dart';

class PresentationScreenTwo extends StatefulWidget {
  final AgendaItemModel? activeAgendaItem;
  final SettingsModel? settings;
  final Size size;
  final bool isPreview;

  const PresentationScreenTwo({
    super.key,
    required this.activeAgendaItem,
    required this.settings,
    required this.size,
    this.isPreview = false,
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
    final p = widget.size.width / 1920.0;

    if (widget.activeAgendaItem is AgendaItemModelLiveCompetition) {
      final AgendaItemModelLiveCompetition agendaItem =
          widget.activeAgendaItem as AgendaItemModelLiveCompetition;

      return CurrentIntegralStream(
        integralCode: agendaItem.currentIntegralCode,
        builder: (context, currentIntegral) {
          final youtubeVideoId = currentIntegral?.youtubeVideoId ?? '';

          if (youtubeVideoId != '' &&
              agendaItem.problemPhase == ProblemPhase.idle) {
            if (widget.isPreview) {
              return Text(
                MyIntl.of(context).videoPlaceholder,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 100 * p),
              );
            } else {
              return YoutubeView(
                size: widget.size,
                videoId: youtubeVideoId,
              );
            }
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
