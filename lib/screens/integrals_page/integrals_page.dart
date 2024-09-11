import 'package:flutter/material.dart';
import 'package:integration_bee_helper/screens/integrals_page/integrals_add_bulk_dialog.dart';
import 'package:integration_bee_helper/screens/integrals_page/integrals_list.dart';

class IntegralsPage extends StatefulWidget {
  const IntegralsPage({super.key});

  @override
  State<IntegralsPage> createState() => _IntegralsPageState();
}

class _IntegralsPageState extends State<IntegralsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  onPressed: () => IntegralsAddBulkDialog.launch(context),
                  child: const Icon(Icons.list),
                ),
                const SizedBox(height: 16),
                FloatingActionButton(
                  onPressed:
                      () {}, // () => IntegralsService().addIntegral(currentIntegrals: integrals),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
      body: IntegralsList(),
    );
  }
}
