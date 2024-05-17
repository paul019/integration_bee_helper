import 'dart:async';

import 'package:flutter/material.dart';
import 'package:integration_bee_helper/extensions/exception_extension.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_knockout.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_phase.dart';
import 'package:integration_bee_helper/models/agenda_item_model/problem_phase.dart';
import 'package:integration_bee_helper/models/agenda_item_model/score.dart';
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
          onPressed: () {
            try {
              widget.activeAgendaItem.startIntegral();
            } on Exception catch (e) {
              e.show(context);
            }
          },
          child: const Text('Start'),
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
                  ? const Text('Resume timer')
                  : const Text('Pause timer'),
            ),
            const VerticalSeparator(),
            if (widget.activeAgendaItem.problemPhase ==
                ProblemPhase.showProblem)
              TextButton(
                onPressed: () {
                  ConfirmationDialog(
                    bypassConfirmation: widget.activeAgendaItem.timer.timeUp!,
                    title: 'Do you really want to show the solution?',
                    payload: () => widget.activeAgendaItem.showSolution(),
                  ).launch(context);
                },
                child: const Text('Show solution'),
              ),
            if (widget.activeAgendaItem.problemPhase ==
                ProblemPhase.showProblem)
              const VerticalSeparator(),
            TextButton(
              onPressed: () =>
                  widget.activeAgendaItem.setWinner(Score.competitor1),
              child: Text('${widget.activeAgendaItem.competitor1Name} wins'),
            ),
            const VerticalSeparator(),
            TextButton(
              onPressed: () =>
                  widget.activeAgendaItem.setWinner(Score.competitor2),
              child: Text('${widget.activeAgendaItem.competitor2Name} wins'),
            ),
            const VerticalSeparator(),
            TextButton(
              onPressed: () => widget.activeAgendaItem.setWinner(Score.tie),
              child: const Text('Draw'),
            ),
          ],
        );
      case ProblemPhase.showSolutionAndWinner:
        if (widget.activeAgendaItem.phase == AgendaItemPhase.activeButFinished) {
          return Text(
            widget.activeAgendaItem.status ?? '',
            style: const TextStyle(fontWeight: FontWeight.bold),
          );
        } else {
          return TextButton(
            onPressed: () async {
              throw UnimplementedError();
              final success =
                  await widget.activeAgendaItem.startNextRegularIntegral();

              if (success && context.mounted) {
                showDialog(
                    context: context,
                    builder: (BuildContext dialogContext) => AlertDialog(
                          title: const Text('Not enough spare integrals'),
                          content: const Text(
                              'Please add new unused spare integrals.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('OK'),
                            ),
                          ],
                        ));
              }
            },
            child: const Text('Next integral'),
          );
        }
      default:
        return Container();
    }
  }
}
