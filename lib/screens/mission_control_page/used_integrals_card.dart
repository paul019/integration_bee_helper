import 'package:flutter/material.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_model.dart';
import 'package:integration_bee_helper/models/integral_model/integral_model.dart';
import 'package:integration_bee_helper/services/integrals_service.dart';
import 'package:integration_bee_helper/widgets/confirmation_dialog.dart';
import 'package:provider/provider.dart';

class UsedIntegralsCard extends StatelessWidget {
  final AgendaItemModel? activeAgendaItem;

  const UsedIntegralsCard({super.key, required this.activeAgendaItem});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<IntegralModel>?>.value(
      initialData: null,
      value:  IntegralsService().onUsedIntegralsChanged,
      builder: (context, snapshot) {
        final integrals = Provider.of<List<IntegralModel>?>(context);
        final integralCodes = integrals?.map((e) => e.code).toList();

        if (integrals != null && integrals.isEmpty) {
          return const SizedBox();
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Used spare Integrals:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          integralCodes?.join(', ') ??
                              'Could not load used spare integrals.',
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: integrals != null
                        ? () {
                            ConfirmationDialog(
                              title: 'Do you really want to reset this list?',
                              description: 'Spare integrals will be re-used.',
                              payload: () =>
                                   IntegralsService().resetUsedIntegrals(integrals),
                            ).launch(context);
                          }
                        : null,
                    child: const Text('Reset'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
