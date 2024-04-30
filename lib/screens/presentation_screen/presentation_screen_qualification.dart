import 'dart:async';

import 'package:flutter/material.dart';
import 'package:integration_bee_helper/models/agenda_item_model.dart';
import 'package:integration_bee_helper/models/integral_model.dart';
import 'package:integration_bee_helper/screens/presentation_screen/integral_code_view.dart';
import 'package:integration_bee_helper/screens/presentation_screen/integral_view.dart';
import 'package:integration_bee_helper/screens/presentation_screen/timer_view.dart';
import 'package:integration_bee_helper/services/integrals_service.dart';
import 'package:just_audio/just_audio.dart';

class PresentationScreenQualification extends StatefulWidget {
  final AgendaItemModel activeAgendaItem;
  final Size size;
  final bool muted;

  const PresentationScreenQualification({
    super.key,
    required this.activeAgendaItem,
    required this.size,
    this.muted = false,
  });

  @override
  State<PresentationScreenQualification> createState() =>
      _PresentationScreenQualificationState();
}

class _PresentationScreenQualificationState
    extends State<PresentationScreenQualification> {
  List<IntegralModel> integrals = [];
  String agendaItemId = '';

  late Timer timer;
  Duration timeLeft = Duration.zero;
  bool timerRed = false;

  late final AudioPlayer player;

  String get uid => widget.activeAgendaItem.uid;
  IntegralsService get integralsService => IntegralsService(uid: uid);
  int get progressIndex => widget.activeAgendaItem.progressIndex!;
  int get phaseIndex => widget.activeAgendaItem.phaseIndex!;
  List<String> get integralsCodes => widget.activeAgendaItem.integralsCodes!;
  List<String> get spareIntegralsCodes =>
      widget.activeAgendaItem.spareIntegralsCodes!;
  String? get currentIntegralCode => widget.activeAgendaItem.currentIntegralCode;
  List<int> get scores {
    final scores = [...widget.activeAgendaItem.scores!];

    if (scores.length < integralsCodes.length) {
      final missing = integralsCodes.length - scores.length;
      for (var i = 0; i < missing; i++) {
        scores.add(-1);
      }
    }

    return scores;
  }

  String? get problemName {
    final numberOfRegularIntegrals = integralsCodes.length;
    if (progressIndex == 0) {
      return null;
    } else {
      return 'Problem 1+${progressIndex - numberOfRegularIntegrals + 1}';
    }
  }

  DateTime? get timerStopsAt => widget.activeAgendaItem.timerStopsAt;

  Duration? get pausedTimerDuration =>
      widget.activeAgendaItem.pausedTimerDuration;

  IntegralModel? get currentIntegral => getIntegral(currentIntegralCode);
  IntegralModel? getIntegral(String? integralCode) {
    try {
      return integrals.firstWhere((integral) => integral.code == integralCode);
    } catch (err) {
      return null;
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

    player = AudioPlayer();

    const timerInterval = Duration(milliseconds: 250);
    const timeWarningDuration = Duration(seconds: 30);

    timer = Timer.periodic(timerInterval, (timer) {
      switch (phaseIndex) {
        case 0:
          if (progressIndex == 0) {
            setState(() {
              timeLeft = widget.activeAgendaItem.timeLimitPerIntegral!;
              timerRed = false;
            });
          } else {
            setState(() {
              timeLeft = widget.activeAgendaItem.timeLimitPerSpareIntegral!;
              timerRed = false;
            });
          }
          break;
        case 1:
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
        case 2:
        case 3:
        default:
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
    if (widget.muted) return;
    player.setAsset('time_warning.mp3').then((_) => player.play());
  }

  void playTimeUpSound() {
    if (widget.muted) return;
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
    if (agendaItemId != widget.activeAgendaItem.id!) {
      initialize();
    }

    // final p = size.width / 1920.0;

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
          phaseIndex: phaseIndex,
          problemName: problemName,
          size: widget.size,
        ),
        IntegralCodeView(
          code: currentIntegralCode ?? '',
          size: widget.size,
        ),
      ],
    );
  }
}
