import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:integration_bee_helper/models/integral_model.dart';
import 'package:integration_bee_helper/services/latex_transformer.dart';

class IntegralView extends StatelessWidget {
  final IntegralModel? currentIntegral;
  final int phaseIndex;
  final String? problemName;
  final Size size;

  const IntegralView({
    super.key,
    required this.currentIntegral,
    required this.phaseIndex,
    required this.problemName,
    required this.size,
  });

  String get latex {
    switch (phaseIndex) {
      case 0:
        return '';
      case 1:
        return currentIntegral?.latexProblem ?? '';
      case 2:
      case 3:
        return '${currentIntegral?.latexProblem ?? ''}=\\boxed{${currentIntegral?.latexSolution ?? ''}}';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = size.width / 1920.0;

    if (phaseIndex == 0) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            problemName != null
                ? 'Coming up: $problemName'
                : 'Next problem coming up',
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
          LatexTransformer.transform(latex),
          style: TeXViewStyle.fromCSS(
              'padding: 5px; font-size: ${(75 * p).toInt()}px'),
        ),
      ),
    );
  }
}
