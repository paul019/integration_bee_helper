import 'package:flutter/material.dart';
import 'package:integration_bee_helper/models/integral_model/current_integral_wrapper.dart';
import 'package:integration_bee_helper/models/integral_model/integral_model.dart';
import 'package:integration_bee_helper/services/integrals_service/integrals_service.dart';
import 'package:provider/provider.dart';

class CurrentIntegralStream extends StatelessWidget {
  final String? integralCode;
  final Widget Function(BuildContext, IntegralModel?) builder;

  const CurrentIntegralStream({
    super.key,
    required this.integralCode,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return StreamProvider<CurrentIntegralWrapper>.value(
      initialData: CurrentIntegralWrapper(null),
      value: IntegralsService().onCurrentIntegralChanged(
        integralCode: integralCode,
      ),
      builder: (context, snapshot) {
        final integralWrapper = Provider.of<CurrentIntegralWrapper>(context);
        final currentIntegral = integralWrapper.integral;

        return builder(context, currentIntegral);
      },
    );
  }
}
