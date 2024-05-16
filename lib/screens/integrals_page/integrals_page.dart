import 'package:flutter/material.dart';
import 'package:integration_bee_helper/models/integral_model/integral_model.dart';
import 'package:integration_bee_helper/screens/integrals_page/integral_card.dart';
import 'package:integration_bee_helper/services/integrals_service/integrals_service.dart';
import 'package:integration_bee_helper/widgets/loading_screen.dart';
import 'package:integration_bee_helper/widgets/max_width_wrapper.dart';
import 'package:provider/provider.dart';

class IntegralsPage extends StatefulWidget {
  const IntegralsPage({super.key});

  @override
  State<IntegralsPage> createState() => _IntegralsPageState();
}

class _IntegralsPageState extends State<IntegralsPage> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<IntegralModel>?>.value(
        initialData: null,
        value:  IntegralsService().onIntegralsChanged,
        builder: (context, snapshot) {
          final integrals = Provider.of<List<IntegralModel>?>(context);

          if (integrals == null) {
            return const LoadingScreen();
          }

          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () =>  IntegralsService().addIntegral(currentIntegrals: integrals),
              child: const Icon(Icons.add),
            ),
            body: ListView.builder(
              itemCount: integrals.length,
              itemBuilder: (context, index) {
                final integral = integrals[index];
            
                return MaxWidthWrapper(
                  child: IntegralCard(
                    integral: integral,
                  ),
                );
              },
            ),
          );
        });
  }
}
