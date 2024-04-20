import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:integration_bee_helper/models/agenda_item_model.dart';
import 'package:integration_bee_helper/services/agenda_items_service.dart';
import 'package:integration_bee_helper/widgets/confirmation_dialog.dart';
import 'package:provider/provider.dart';

class KnockoutControlElements extends StatefulWidget {
  final AgendaItemModel activeAgendaItem;

  const KnockoutControlElements({super.key, required this.activeAgendaItem});

  @override
  State<KnockoutControlElements> createState() => _KnockoutControlElementsState();
}

class _KnockoutControlElementsState extends State<KnockoutControlElements> {
  late Timer timer;
  bool timeUp = false;

  @override
  void initState() {
    const timerInterval = Duration(milliseconds: 250);

    timer = Timer.periodic(timerInterval, (timer) {
      if(widget.activeAgendaItem.timerStopsAt == null) {
        setState(() => timeUp = false);
      } else {
        setState(() => timeUp = widget.activeAgendaItem.timerStopsAt!.isBefore(DateTime.now()));
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
    final authModel = Provider.of<User?>(context)!;
    final service = AgendaItemsService(uid: authModel.uid);

    switch (widget.activeAgendaItem.phaseIndex!) {
      case 0:
        return TextButton(
          onPressed: () =>
              service.knockoutRound_startIntegral(widget.activeAgendaItem),
          child: const Text('Start!'),
        );
      case 1:
      case 2:
        final timerPaused = widget.activeAgendaItem.pausedTimerDuration != null;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: timeUp ? null: () {
                if (timerPaused) {
                  service.knockoutRound_resumeTimer(widget.activeAgendaItem);
                } else {
                  service.knockoutRound_pauseTimer(widget.activeAgendaItem);
                }
              },
              child: timerPaused
                  ? const Text('Resume timer')
                  : const Text('Pause timer'),
            ),
            separator(),
            if (widget.activeAgendaItem.phaseIndex! == 1)
              TextButton(
                onPressed: () {
                  if (widget.activeAgendaItem.timerStopsAt!.isAfter(DateTime.now())) {
                    ConfirmationDialog(
                      title: 'Do you really want to show the solution?',
                      payload: () =>
                          service.knockoutRound_showSolution(widget.activeAgendaItem),
                    ).launch(context);
                  } else {
                    service.knockoutRound_showSolution(widget.activeAgendaItem);
                  }
                },
                child: const Text('Show solution'),
              ),
            if (widget.activeAgendaItem.phaseIndex! == 1) separator(),
            TextButton(
              onPressed: () =>
                  service.knockoutRound_setWinner(widget.activeAgendaItem, 1),
              child: Text('${widget.activeAgendaItem.competitor1Name} wins'),
            ),
            separator(),
            TextButton(
              onPressed: () =>
                  service.knockoutRound_setWinner(widget.activeAgendaItem, 2),
              child: Text('${widget.activeAgendaItem.competitor2Name} wins'),
            ),
            separator(),
            TextButton(
              onPressed: () =>
                  service.knockoutRound_setWinner(widget.activeAgendaItem, 0),
              child: const Text('Draw'),
            ),
          ],
        );
      case 3:
        if (widget.activeAgendaItem.finished) {
          return Text(
            widget.activeAgendaItem.status,
            style: const TextStyle(fontWeight: FontWeight.bold),
          );
        } else {
          return TextButton(
            onPressed: () =>
                service.knockoutRound_nextIntegral(widget.activeAgendaItem),
            child: const Text('Next integral'),
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
