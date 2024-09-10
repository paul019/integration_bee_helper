import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:integration_bee_helper/models/agenda_item_model/problem_phase.dart';
import 'package:integration_bee_helper/models/integral_model/integral_model.dart';
import 'package:integration_bee_helper/services/basic_services/intl_service.dart';

class IntegralView extends StatelessWidget {
  final IntegralModel? currentIntegral;
  final ProblemPhase problemPhase;
  final String? problemName;
  final Size size;

  const IntegralView({
    super.key,
    required this.currentIntegral,
    required this.problemPhase,
    required this.problemName,
    required this.size,
  });

  String get latex {
    switch (problemPhase) {
      case ProblemPhase.idle:
        return '';
      case ProblemPhase.showProblem:
        return currentIntegral?.latexProblem.transformedWithDollarSigns ?? '';
      case ProblemPhase.showSolution:
      case ProblemPhase.showSolutionAndWinner:
        return currentIntegral
                ?.latexProblemAndSolution.transformedWithDollarSigns ??
            '';
      default:
        return '';
    }
  }

  int get _integralSize => latex.length > 75 ? 50 : 75;

  @override
  Widget build(BuildContext context) {
    final p = size.width / 1920.0;

    if (problemPhase == ProblemPhase.idle) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            problemName != null
                ? MyIntl.of(context).comingUpTitle(problemName!)
                : MyIntl.of(context).nextIntegralComingUp,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 100 * p),
          ),
          if ((currentIntegral?.name ?? '') != '')
            Text(
              currentIntegral?.name ?? '',
              style: TextStyle(fontSize: 60 * p),
            ),
        ],
      );
    }

    return Container(
      width: size.width,
      height: size.height,
      alignment: Alignment.center,
      child: TeXView(
        child: TeXViewDocument(
          latex,
          style: TeXViewStyle.fromCSS(
            'padding: 5px; font-size: ${(_integralSize * p).toInt()}px',
          ),
        ),
      ),
    );
  }
}