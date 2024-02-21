import 'package:flutter/material.dart';
import 'package:integration_bee_helper/models/integral_model.dart';
import 'package:integration_bee_helper/services/integrals_service.dart';
import 'package:integration_bee_helper/widgets/loading_screen.dart';
import 'package:integration_bee_helper/widgets/max_width_wrapper.dart';
import 'package:provider/provider.dart';

class IntegralsPage extends StatefulWidget {
  const IntegralsPage({super.key});

  @override
  State<IntegralsPage> createState() => _IntegralsPageState();
}

class _IntegralsPageState extends State<IntegralsPage> {
  final service = IntegralsService();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<IntegralModel>?>.value(
        initialData: null,
        value: service.onIntegralsChanged,
        builder: (context, snapshot) {
          final integrals = Provider.of<List<IntegralModel>?>(context);

          if (integrals == null) {
            return const LoadingScreen();
          }

          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () => service.addIntegral(currentIntegrals: integrals),
              child: const Icon(Icons.add),
            ),
            body: MaxWidthWrapper(
              child: ListView.builder(
                itemCount: integrals.length,
                itemBuilder: (context, index) {
                  final integral = integrals[index];

                  return ListTile(
                    title: Text(integral.code),
                  );
                },
              ),
            ),
          );
        });
  }
}
