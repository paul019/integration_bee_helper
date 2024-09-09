import 'dart:async';

import 'package:flutter/material.dart';
import 'package:integration_bee_helper/extensions/exception_extension.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_phase.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_qualification.dart';
import 'package:integration_bee_helper/models/agenda_item_model/problem_phase.dart';
import 'package:integration_bee_helper/screens/mission_control_page/spare_integral_dialog.dart';
import 'package:integration_bee_helper/services/basic_services/intl_service.dart';
import 'package:integration_bee_helper/widgets/confirmation_dialog.dart';

class QualificationControlElements extends StatefulWidget {
  final AgendaItemModelQualification activeAgendaItem;

  const QualificationControlElements(
      {super.key, required this.activeAgendaItem});

  @override
  State<QualificationControlElements> createState() =>
      _QualificationControlElementsState();
}

class _QualificationControlElementsState
    extends State<QualificationControlElements> {
  late Timer timer;
  bool timeUp = false;

  @override
  void initState() {
    const timerInterval = Duration(milliseconds: 250);

    timer = Timer.periodic(timerInterval, (timer) {
      if (widget.activeAgendaItem.timer.timerStopsAt == null) {
        setState(() => timeUp = false);
      } else {
        setState(() => timeUp = widget.activeAgendaItem.timer.timerStopsAt!
            .isBefore(DateTime.now()));
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
    switch (widget.activeAgendaItem.problemPhase) {
      case ProblemPhase.idle:
        return TextButton(
          onPressed: () async {
            try {
              await widget.activeAgendaItem.startIntegral();
            } on Exception catch (e) {
              if (context.mounted) e.show(context);
            }
          },
          child: Text(MyIntl.of(context).startExclamationMark),
        );
      case ProblemPhase.showProblem:
        final timerPaused = widget.activeAgendaItem.timer.paused;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: timeUp
                  ? null
                  : () {
                      if (timerPaused) {
                        widget.activeAgendaItem.resumeTimer();
                      } else {
                        widget.activeAgendaItem.pauseTimer();
                      }
                    },
              child: timerPaused
                  ? Text(MyIntl.of(context).resumeTimer)
                  : Text(MyIntl.of(context).pauseTimer),
            ),
            separator(),
            TextButton(
              onPressed: () {
                ConfirmationDialog(
                  bypassConfirmation: widget.activeAgendaItem.timer.timeUp,
                  title: MyIntl.of(context).doYouReallyWantToShowTheSolution,
                  payload: () => widget.activeAgendaItem.showSolution(),
                ).launch(context);
              },
              child: Text(MyIntl.of(context).showSolution),
            ),
          ],
        );
      case ProblemPhase.showSolution:
      case ProblemPhase.showSolutionAndWinner:
        if (widget.activeAgendaItem.phase ==
            AgendaItemPhase.activeButFinished) {
          return Text(
            widget.activeAgendaItem.status ?? '',
            style: const TextStyle(fontWeight: FontWeight.bold),
          );
        } else {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () async {
                  try {
                    final potentialSpareIntegrals = await widget
                        .activeAgendaItem
                        .getPotentialSpareIntegrals();

                    if (context.mounted) {
                      SpareIntegralDialog.launch(
                        context,
                        potentialSpareIntegrals: potentialSpareIntegrals,
                        onChoose: (integral) async {
                          try {
                            await widget.activeAgendaItem
                                .startNextSpareIntegral(integral.code);
                          } on Exception catch (e) {
                            if (context.mounted) e.show(context);
                          }
                        },
                      );
                    }
                  } on Exception catch (e) {
                    if (context.mounted) e.show(context);
                  }
                },
                child: Text(MyIntl.of(context).additionalIntegral),
              ),
              separator(),
              TextButton(
                onPressed: () {
                  ConfirmationDialog(
                    title:
                        MyIntl.of(context).doYouReallyWantToFinishThisQualificationRound,
                    payload: () => widget.activeAgendaItem.setToFinished(),
                  ).launch(context);
                },
                child: Text(MyIntl.of(context).qualificationRoundFinished),
              ),
            ],
          );
        }
    }
  }

  Widget separator() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Text('|'),
    );
  }
}
