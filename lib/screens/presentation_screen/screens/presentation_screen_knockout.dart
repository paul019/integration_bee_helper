import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_knockout.dart';
import 'package:integration_bee_helper/models/integral_model/integral_type.dart';
import 'package:integration_bee_helper/models/agenda_item_model/problem_phase.dart';
import 'package:integration_bee_helper/models/agenda_item_model/score.dart';
import 'package:integration_bee_helper/screens/presentation_screen/widgets/integral_code_view.dart';
import 'package:integration_bee_helper/screens/presentation_screen/widgets/integral_view.dart';
import 'package:integration_bee_helper/screens/presentation_screen/widgets/score_view.dart';
import 'package:integration_bee_helper/screens/presentation_screen/widgets/timer_view.dart';
import 'package:integration_bee_helper/screens/presentation_screen/widgets/title_view.dart';
import 'package:integration_bee_helper/services/basic_services/intl_service.dart';
import 'package:integration_bee_helper/widgets/current_integral_stream.dart';

class PresentationScreenKnockout extends StatefulWidget {
  final AgendaItemModelKnockout activeAgendaItem;
  final Size size;
  final bool isPreview;

  const PresentationScreenKnockout({
    super.key,
    required this.activeAgendaItem,
    required this.size,
    required this.isPreview,
  });

  @override
  State<PresentationScreenKnockout> createState() =>
      _PresentationScreenKnockoutState();
}

class _PresentationScreenKnockoutState
    extends State<PresentationScreenKnockout> {
  String agendaItemId = '';

  late final ConfettiController competitor1ConfettiController;
  late final ConfettiController competitor2ConfettiController;

  String get uid => widget.activeAgendaItem.uid;
  ProblemPhase get problemPhase => widget.activeAgendaItem.problemPhase;
  List<String> get integralsCodes => widget.activeAgendaItem.integralsCodes;
  List<String> get spareIntegralsCodes =>
      widget.activeAgendaItem.spareIntegralsCodes;
  String? get currentIntegralCode =>
      widget.activeAgendaItem.currentIntegralCode;
  List<Score> get scores {
    final scores = [...widget.activeAgendaItem.scores];

    if (scores.length < widget.activeAgendaItem.numOfIntegrals) {
      final missing = integralsCodes.length - scores.length;
      for (var i = 0; i < missing; i++) {
        scores.add(Score.notSetYet);
      }
    }

    return scores;
  }

  String get problemName {
    if (widget.activeAgendaItem.currentIntegralType == IntegralType.regular) {
      return MyIntl.of(context).exerciseNumber(
        widget.activeAgendaItem.integralsProgress! + 1,
      );
    } else {
      return MyIntl.of(context).extraExerciseNumber(
        widget.activeAgendaItem.numOfIntegrals,
        widget.activeAgendaItem.spareIntegralsProgress! + 1,
      );
    }
  }

  void initialize() async {
    agendaItemId = widget.activeAgendaItem.id;

    setState(() {});
  }

  @override
  void initState() {
    initialize();

    competitor1ConfettiController =
        ConfettiController(duration: const Duration(seconds: 10));
    competitor2ConfettiController =
        ConfettiController(duration: const Duration(seconds: 10));

    super.initState();
  }

  @override
  void dispose() {
    competitor1ConfettiController.dispose();
    competitor2ConfettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (agendaItemId != widget.activeAgendaItem.id) {
      initialize();
    }

    // final p = size.width / 1920.0;

    return CurrentIntegralStream(
      integralCode: widget.activeAgendaItem.currentIntegralCode,
      builder: (context, currentIntegral) {
        return Stack(
          alignment: Alignment.center,
          children: [
            TimerView(
              activeAgendaItem: widget.activeAgendaItem,
              size: widget.size,
              isPreview: widget.isPreview,
              competitor1ConfettiController: competitor1ConfettiController,
              competitor2ConfettiController: competitor2ConfettiController,
            ),
            ScoreView(
              competitor1Name: widget.activeAgendaItem.competitor1Name,
              competitor2Name: widget.activeAgendaItem.competitor2Name,
              scores: scores,
              totalProgress: widget.activeAgendaItem.totalProgress ?? 0,
              problemName: problemName,
              size: widget.size,
              competitor1ConfettiController: competitor1ConfettiController,
              competitor2ConfettiController: competitor2ConfettiController,
            ),
            IntegralView(
              currentIntegral: currentIntegral,
              problemPhase: problemPhase,
              problemName: problemName,
              size: widget.size,
            ),
            IntegralCodeView(
              code: currentIntegralCode ?? '',
              size: widget.size,
            ),
            TitleView(title: widget.activeAgendaItem.title, size: widget.size),
          ],
        );
      },
    );
  }
}
