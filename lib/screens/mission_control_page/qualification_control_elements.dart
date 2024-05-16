import 'dart:async';

import 'package:flutter/material.dart';
import 'package:integration_bee_helper/extensions/exception_extension.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_qualification.dart';
import 'package:integration_bee_helper/models/agenda_item_model/problem_phase.dart';
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
          onPressed: () {
            try {
              widget.activeAgendaItem.startIntegral();
            } on Exception catch (e) {
              e.show(context);
            }
          },
          child: const Text('Start!'),
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
                  ? const Text('Resume timer')
                  : const Text('Pause timer'),
            ),
            separator(),
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
          ],
        );
      case ProblemPhase.showSolution:
        if (widget.activeAgendaItem.finished) {
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
                  throw UnimplementedError();
                  final success = false;

                  if (!success && context.mounted) {
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
                child: const Text('Additional integral'),
              ),
              separator(),
              TextButton(
                onPressed: () {
                  ConfirmationDialog(
                    title:
                        'Do you really want to finish this qualification round?',
                    payload: () => widget.activeAgendaItem.setToFinished(),
                  ).launch(context);
                },
                child: const Text('Qualification round finished'),
              ),
            ],
          );
        }
      default:
        return Container();
    }
  }

  Widget separator() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Text('|'),
    );
  }
}
