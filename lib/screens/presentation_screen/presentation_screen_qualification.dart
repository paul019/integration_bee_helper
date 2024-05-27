import 'dart:async';

import 'package:flutter/material.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_qualification.dart';
import 'package:integration_bee_helper/models/integral_model/current_integral_wrapper.dart';
import 'package:integration_bee_helper/models/integral_model/integral_type.dart';
import 'package:integration_bee_helper/models/agenda_item_model/problem_phase.dart';
import 'package:integration_bee_helper/screens/presentation_screen/integral_code_view.dart';
import 'package:integration_bee_helper/screens/presentation_screen/integral_view.dart';
import 'package:integration_bee_helper/screens/presentation_screen/names_view.dart';
import 'package:integration_bee_helper/screens/presentation_screen/timer_view.dart';
import 'package:integration_bee_helper/screens/presentation_screen/title_view.dart';
import 'package:integration_bee_helper/services/integrals_service/integrals_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

class PresentationScreenQualification extends StatefulWidget {
  final AgendaItemModelQualification activeAgendaItem;
  final Size size;
  final bool isPreview;

  const PresentationScreenQualification({
    super.key,
    required this.activeAgendaItem,
    required this.size,
    required this.isPreview,
  });

  @override
  State<PresentationScreenQualification> createState() =>
      _PresentationScreenQualificationState();
}

class _PresentationScreenQualificationState
    extends State<PresentationScreenQualification> {
  String agendaItemId = '';

  late Timer timer;
  Duration timeLeft = Duration.zero;
  bool timerRed = false;

  late final AudioPlayer player;

  String get uid => widget.activeAgendaItem.uid;
  ProblemPhase get problemPhase => widget.activeAgendaItem.problemPhase;
  List<String> get integralsCodes => widget.activeAgendaItem.integralsCodes;
  List<String> get spareIntegralsCodes =>
      widget.activeAgendaItem.spareIntegralsCodes;
  String? get currentIntegralCode =>
      widget.activeAgendaItem.currentIntegralCode;

  String? get problemName {
    if (widget.activeAgendaItem.currentIntegralType == IntegralType.regular) {
      return null;
    } else {
      return 'Aufgabe 1+${widget.activeAgendaItem.spareIntegralsProgress! + 1}';
    }
  }

  DateTime? get timerStopsAt => widget.activeAgendaItem.timer.timerStopsAt;

  Duration? get pausedTimerDuration =>
      widget.activeAgendaItem.timer.pausedTimerDuration;

  void initialize() async {
    agendaItemId = widget.activeAgendaItem.id;

    setState(() {});
  }

  @override
  void initState() {
    initialize();

    player = AudioPlayer();

    const timerInterval = Duration(milliseconds: 250);
    const timeWarningDuration = Duration(seconds: 30);

    timer = Timer.periodic(timerInterval, (timer) {
      switch (problemPhase) {
        case ProblemPhase.idle:
          if (widget.activeAgendaItem.currentIntegralType ==
              IntegralType.regular) {
            setState(() {
              timeLeft = widget.activeAgendaItem.timeLimitPerIntegral;
              timerRed = false;
            });
          } else {
            setState(() {
              timeLeft = widget.activeAgendaItem.timeLimitPerSpareIntegral;
              timerRed = false;
            });
          }
          break;
        case ProblemPhase.showProblem:
          if (pausedTimerDuration != null) {
            setState(() {
              timeLeft = pausedTimerDuration!;
              timerRed = pausedTimerDuration! <
                  timeWarningDuration + const Duration(seconds: 1);
            });
          } else if (timerStopsAt == null) {
            setState(() {
              timeLeft = Duration.zero;
              timerRed = false;
            });
          } else {
            final difference = timerStopsAt!.difference(DateTime.now());

            setState(() {
              timeLeft = difference.isNegative ? Duration.zero : difference;
              timerRed =
                  difference < timeWarningDuration + const Duration(seconds: 1);
            });

            if (difference < timeWarningDuration + const Duration(seconds: 1) &&
                difference + timerInterval >
                    timeWarningDuration + const Duration(seconds: 1)) {
              playWarningSound();
            }
            if (difference < Duration.zero &&
                difference + timerInterval > Duration.zero) {
              playTimeUpSound();
            }
          }
          break;
        case ProblemPhase.showSolution:
        case ProblemPhase.showSolutionAndWinner:
          setState(() {
            timeLeft = Duration.zero;
            timerRed = false;
          });
          break;
      }
    });

    super.initState();
  }

  void playWarningSound() {
    if (widget.isPreview) return;
    player.setAsset('time_warning.mp3').then((_) => player.play());
  }

  void playTimeUpSound() {
    if (widget.isPreview) return;
    player.setAsset('time_up.mp3').then((_) => player.play());
  }

  @override
  void dispose() {
    timer.cancel();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (agendaItemId != widget.activeAgendaItem.id) {
      initialize();
    }

    // final p = size.width / 1920.0;

    return StreamProvider<CurrentIntegralWrapper>.value(
        initialData: CurrentIntegralWrapper(null),
        value: IntegralsService().onCurrentIntegralChanged(
          integralCode: widget.activeAgendaItem.currentIntegralCode,
        ),
        builder: (context, snapshot) {
          final integralWrapper = Provider.of<CurrentIntegralWrapper>(context);
          final currentIntegral = integralWrapper.integral;

          return Stack(
            alignment: Alignment.center,
            children: [
              TimerView(
                timeLeft: timeLeft,
                timerRed: timerRed,
                paused: pausedTimerDuration != null,
                size: widget.size,
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
              TitleView(
                title: widget.activeAgendaItem.title,
                size: widget.size,
              ),
              NamesView(
                competitorNames: widget.activeAgendaItem.competitorNames,
                problemName: problemName ?? 'Aufgabe 1',
                size: widget.size,
              ),
            ],
          );
        });
  }
}
