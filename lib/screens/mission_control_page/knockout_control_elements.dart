import 'dart:async';

import 'package:flutter/material.dart';
import 'package:integration_bee_helper/extensions/exception_extension.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_knockout.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_phase.dart';
import 'package:integration_bee_helper/models/agenda_item_model/problem_phase.dart';
import 'package:integration_bee_helper/models/agenda_item_model/score.dart';
import 'package:integration_bee_helper/models/integral_model/integral_type.dart';
import 'package:integration_bee_helper/screens/mission_control_page/spare_integral_dialog.dart';
import 'package:integration_bee_helper/services/basic_services/intl_service.dart';
import 'package:integration_bee_helper/widgets/confirmation_dialog.dart';
import 'package:integration_bee_helper/widgets/vertical_separator.dart';

class KnockoutControlElements extends StatefulWidget {
  final AgendaItemModelKnockout activeAgendaItem;

  const KnockoutControlElements({super.key, required this.activeAgendaItem});

  @override
  State<KnockoutControlElements> createState() =>
      _KnockoutControlElementsState();
}

class _KnockoutControlElementsState extends State<KnockoutControlElements> {
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
          child: Text(MyIntl.of(context).start),
        );
      case ProblemPhase.showProblem:
      case ProblemPhase.showSolution:
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
            const VerticalSeparator(),
            if (widget.activeAgendaItem.problemPhase ==
                ProblemPhase.showProblem)
              TextButton(
                onPressed: () {
                  ConfirmationDialog(
                    positiveText: MyIntl.of(context).yes,
                    negativeText: MyIntl.of(context).cancel,
                    bypassConfirmation: widget.activeAgendaItem.timer.timeUp!,
                    title: MyIntl.of(context).doYouReallyWantToShowTheSolution,
                    payload: () => widget.activeAgendaItem.showSolution(),
                  ).launch(context);
                },
                child: Text(MyIntl.of(context).showSolution),
              ),
            if (widget.activeAgendaItem.problemPhase ==
                ProblemPhase.showProblem)
              const VerticalSeparator(),
            TextButton(
              onPressed: () =>
                  widget.activeAgendaItem.setWinner(Score.competitor1, context),
              child: Text(MyIntl.of(context)
                  .personWins(widget.activeAgendaItem.competitor1Name)),
            ),
            const VerticalSeparator(),
            TextButton(
              onPressed: () =>
                  widget.activeAgendaItem.setWinner(Score.competitor2, context),
              child: Text(MyIntl.of(context)
                  .personWins(widget.activeAgendaItem.competitor2Name)),
            ),
            const VerticalSeparator(),
            TextButton(
              onPressed: () =>
                  widget.activeAgendaItem.setWinner(Score.tie, context),
              child: Text(MyIntl.of(context).draw),
            ),
          ],
        );
      case ProblemPhase.showSolutionAndWinner:
        if (widget.activeAgendaItem.phase ==
            AgendaItemPhase.activeButFinished) {
          return Text(
            widget.activeAgendaItem.status ?? '',
            style: const TextStyle(fontWeight: FontWeight.bold),
          );
        } else {
          return TextButton(
            onPressed: () async {
              if (widget.activeAgendaItem.nextIntegralType ==
                  IntegralType.regular) {
                try {
                  await widget.activeAgendaItem.startNextRegularIntegral();
                } on Exception catch (e) {
                  if (context.mounted) e.show(context);
                }
              } else {
                try {
                  final potentialSpareIntegrals = await widget.activeAgendaItem
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
              }
            },
            child: Text(MyIntl.of(context).nextIntegral),
          );
        }
      default:
        return Container();
    }
  }
}
