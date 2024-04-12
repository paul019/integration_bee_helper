import 'dart:async';

import 'package:flutter/material.dart';
import 'package:integration_bee_helper/models/agenda_item_model.dart';
import 'package:integration_bee_helper/models/integral_model.dart';
import 'package:integration_bee_helper/screens/presentation_screen/integral_code_view.dart';
import 'package:integration_bee_helper/screens/presentation_screen/integral_view.dart';
import 'package:integration_bee_helper/screens/presentation_screen/score_view.dart';
import 'package:integration_bee_helper/screens/presentation_screen/timer_view.dart';
import 'package:integration_bee_helper/services/integrals_service.dart';

class PresentationScreenKnockout extends StatefulWidget {
  final AgendaItemModel activeAgendaItem;
  final Size size;

  const PresentationScreenKnockout({
    super.key,
    required this.activeAgendaItem,
    required this.size,
  });

  @override
  State<PresentationScreenKnockout> createState() =>
      _PresentationScreenKnockoutState();
}

class _PresentationScreenKnockoutState
    extends State<PresentationScreenKnockout> {
  List<IntegralModel> integrals = [];
  String agendaItemId = '';

  late Timer timer;
  Duration timeLeft = Duration.zero;

  String get uid => widget.activeAgendaItem.uid;
  IntegralsService get integralsService => IntegralsService(uid: uid);
  int get progressIndex => widget.activeAgendaItem.progressIndex!;
  int get phaseIndex => widget.activeAgendaItem.phaseIndex!;
  List<String> get integralsCodes => widget.activeAgendaItem.integralsCodes!;
  List<String> get spareIntegralsCodes =>
      widget.activeAgendaItem.spareIntegralsCodes!;
  String get currentIntegralCode {
    if (progressIndex < integralsCodes.length) {
      return integralsCodes[progressIndex];
    } else {
      return spareIntegralsCodes[progressIndex - integralsCodes.length];
    }
  }

  DateTime? get timerStopsAt => widget.activeAgendaItem.timerStopsAt;

  Duration? get pausedTimerDuration =>
      widget.activeAgendaItem.pausedTimerDuration;

  IntegralModel? get currentIntegral {
    try {
      return integrals
          .firstWhere((integral) => integral.code == currentIntegralCode);
    } catch (err) {
      return null;
    }
  }

  String get latex {
    switch (phaseIndex) {
      case 0:
        return '???';
      case 1:
        return currentIntegral?.latexProblem ?? '';
      case 2:
      case 3:
        return '${currentIntegral?.latexProblem ?? ''}=\\boxed{${currentIntegral?.latexSolution ?? ''}}';
      default:
        return '';
    }
  }

  void initialize() async {
    integrals = [];
    agendaItemId = widget.activeAgendaItem.id!;

    for (final code in integralsCodes) {
      final integral = await integralsService.getIntegral(code: code);
      integrals.add(integral);
    }

    for (final code in spareIntegralsCodes) {
      final integral = await integralsService.getIntegral(code: code);
      integrals.add(integral);
    }

    setState(() {});
  }

  @override
  void initState() {
    initialize();

    timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (pausedTimerDuration != null) {
        setState(() {
          timeLeft = pausedTimerDuration!;
        });
      } else if (timerStopsAt == null) {
        setState(() {
          timeLeft = Duration.zero;
        });
      } else {
        final difference = timerStopsAt!.difference(DateTime.now());

        setState(() {
          timeLeft = difference.isNegative ? Duration.zero : difference;
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (agendaItemId != widget.activeAgendaItem.id!) {
      initialize();
    }

    // final p = size.width / 1920.0;

    return Stack(
      alignment: Alignment.center,
      children: [
        TimerView(timeLeft: timeLeft, size: widget.size),
        ScoreView(
            competitor1Name: widget.activeAgendaItem.competitor1Name!,
            competitor2Name: widget.activeAgendaItem.competitor2Name!,
            scores: widget.activeAgendaItem.scores!,
            progressIndex: widget.activeAgendaItem.progressIndex!,
            size: widget.size),
        IntegralView(
          latex: latex,
          size: widget.size,
        ),
        IntegralCodeView(
          code: currentIntegralCode,
          size: widget.size,
        ),
      ],
    );
  }
}
