import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:integration_bee_helper/models/basic_models/latex_expression.dart';

class LatexView extends StatelessWidget {
  final LatexExpression latex;
  final double fontSize;

  const LatexView({
    super.key,
    required this.latex,
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Math.tex(
      latex.transformed,
      textStyle: TextStyle(fontSize: fontSize),
    );
  }
}
