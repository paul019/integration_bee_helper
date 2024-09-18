import 'dart:async';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:integration_bee_helper/extensions/duration_extension.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_knockout.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_live_competition.dart';
import 'package:integration_bee_helper/models/agenda_item_model/problem_phase.dart';
import 'package:integration_bee_helper/models/agenda_item_model/score.dart';
import 'package:integration_bee_helper/models/integral_model/integral_type.dart';
import 'package:integration_bee_helper/theme/theme_colors.dart';
import 'package:integration_bee_helper/widgets/triangle_painter.dart';
import 'package:just_audio/just_audio.dart';

class TimerView extends StatefulWidget {
  final AgendaItemModelLiveCompetition activeAgendaItem;
  final Size size;
  final bool isPreview;

  final ConfettiController? competitor1ConfettiController;
  final ConfettiController? competitor2ConfettiController;

  const TimerView({
    super.key,
    required this.activeAgendaItem,
    required this.size,
    required this.isPreview,
    this.competitor1ConfettiController,
    this.competitor2ConfettiController,
  });

  @override
  State<TimerView> createState() => _TimerViewState();
}

class _TimerViewState extends State<TimerView> {
  late Timer timer;
  Duration timeLeft = Duration.zero;
  bool timerRed = false;

  late final AudioPlayer player;

  DateTime? get timerStopsAt => widget.activeAgendaItem.timer.timerStopsAt;
  Duration? get pausedTimerDuration =>
      widget.activeAgendaItem.timer.pausedTimerDuration;
  bool get paused => pausedTimerDuration != null;

  @override
  void initState() {
    player = AudioPlayer();

    const timerInterval = Duration(milliseconds: 250);
    const timeWarningDuration = Duration(seconds: 30);

    timer = Timer.periodic(timerInterval, (timer) {
      switch (widget.activeAgendaItem.problemPhase) {
        case ProblemPhase.idle:
          widget.competitor1ConfettiController?.stop();
          widget.competitor2ConfettiController?.stop();

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
          widget.competitor1ConfettiController?.stop();
          widget.competitor2ConfettiController?.stop();

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
          if (widget.activeAgendaItem is AgendaItemModelKnockout) {
            final knockout = widget.activeAgendaItem as AgendaItemModelKnockout;

            if (knockout.currentWinner == Score.competitor1) {
              if (widget.competitor1ConfettiController?.state !=
                  ConfettiControllerState.playing) {
                widget.competitor1ConfettiController?.play();
              }
            } else if (knockout.currentWinner == Score.competitor2) {
              if (widget.competitor2ConfettiController?.state !=
                  ConfettiControllerState.playing) {
                widget.competitor2ConfettiController?.play();
              }
            }
          }

          setState(() {
            timeLeft = Duration.zero;
            timerRed = false;
          });

          break;
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    player.dispose();
    super.dispose();
  }

  void playWarningSound() {
    if (widget.isPreview) return;
    player.setAsset('sound/time_warning.mp3').then((_) => player.play());
  }

  void playTimeUpSound() {
    if (widget.isPreview) return;
    player.setAsset('sound/time_up.mp3').then((_) => player.play());
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.size.width / 1920.0;

    return Container(
      width: widget.size.width,
      height: widget.size.height,
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 50 * p),
        child: Row(
          children: [
            Container(
              height: 100 * p,
              width: 250 * p,
              color: ThemeColors.blue,
              child: Padding(
                padding: EdgeInsets.only(left: 10 * p),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        timeLeft.timerString(),
                        style: TextStyle(
                          color:
                              timerRed ? ThemeColors.red : ThemeColors.yellow,
                          fontSize: 50 * p,
                        ),
                      ),
                      if (paused)
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0, left: 4.0),
                          child: Icon(
                            Icons.pause,
                            color:
                                timerRed ? ThemeColors.red : ThemeColors.yellow,
                            size: 50 * p,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            TriangleView(
              height: 100 * p,
              width: 20 * p,
            ),
          ],
        ),
      ),
    );
  }
}
