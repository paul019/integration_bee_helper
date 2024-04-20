import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:integration_bee_helper/models/agenda_item_model.dart';
import 'package:integration_bee_helper/services/agenda_items_service.dart';
import 'package:integration_bee_helper/widgets/confirmation_dialog.dart';
import 'package:provider/provider.dart';

class KnockoutControlElements extends StatelessWidget {
  final AgendaItemModel activeAgendaItem;

  const KnockoutControlElements({super.key, required this.activeAgendaItem});

  @override
  Widget build(BuildContext context) {
    final authModel = Provider.of<User?>(context)!;
    final service = AgendaItemsService(uid: authModel.uid);

    switch (activeAgendaItem.phaseIndex!) {
      case 0:
        return TextButton(
          onPressed: () =>
              service.knockoutRound_startIntegral(activeAgendaItem),
          child: const Text('Start!'),
        );
      case 1:
      case 2:
        final timerPaused = activeAgendaItem.pausedTimerDuration != null;
        final timeUp = activeAgendaItem.timerStopsAt!.isBefore(DateTime.now());

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: timeUp ? null: () {
                if (timerPaused) {
                  service.knockoutRound_resumeTimer(activeAgendaItem);
                } else {
                  service.knockoutRound_pauseTimer(activeAgendaItem);
                }
              },
              child: timerPaused
                  ? const Text('Resume timer')
                  : const Text('Pause timer'),
            ),
            separator(),
            if (activeAgendaItem.phaseIndex! == 1)
              TextButton(
                onPressed: () {
                  if (activeAgendaItem.timerStopsAt!.isAfter(DateTime.now())) {
                    ConfirmationDialog(
                      title: 'Do you really want to show the solution?',
                      payload: () =>
                          service.knockoutRound_showSolution(activeAgendaItem),
                    ).launch(context);
                  } else {
                    service.knockoutRound_showSolution(activeAgendaItem);
                  }
                },
                child: const Text('Show solution'),
              ),
            if (activeAgendaItem.phaseIndex! == 1) separator(),
            TextButton(
              onPressed: () =>
                  service.knockoutRound_setWinner(activeAgendaItem, 1),
              child: Text('${activeAgendaItem.competitor1Name} wins'),
            ),
            separator(),
            TextButton(
              onPressed: () =>
                  service.knockoutRound_setWinner(activeAgendaItem, 2),
              child: Text('${activeAgendaItem.competitor2Name} wins'),
            ),
            separator(),
            TextButton(
              onPressed: () =>
                  service.knockoutRound_setWinner(activeAgendaItem, 0),
              child: const Text('Draw'),
            ),
          ],
        );
      case 3:
        if (activeAgendaItem.finished) {
          return Text(
            activeAgendaItem.status,
            style: const TextStyle(fontWeight: FontWeight.bold),
          );
        } else {
          return TextButton(
            onPressed: () =>
                service.knockoutRound_nextIntegral(activeAgendaItem),
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
