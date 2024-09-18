import 'package:flutter/material.dart';
import 'package:integration_bee_helper/screens/integrals_page/integral_add_dialog.dart';
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => IntegralAddDialog.launch(context: context),
        child: const Icon(Icons.add),
      ),
      body: const IntegralsList(),
    );
  }
}
