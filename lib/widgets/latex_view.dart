import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:integration_bee_helper/models/basic_models/latex_expression.dart';

class LatexView extends StatelessWidget {
  final LatexExpression latex;

  const LatexView({super.key, required this.latex});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: TeXView(
        child: TeXViewDocument(
          latex.transformed,
          style: const TeXViewStyle.fromCSS('padding: 5px;'),
        ),
      ),
    );
  }
}
