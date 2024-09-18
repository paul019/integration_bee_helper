import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:integration_bee_helper/models/basic_models/latex_expression.dart';

class LatexView extends StatelessWidget {
  final LatexExpression latex;
  final bool small;

  const LatexView({super.key, required this.latex, this.small = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: small ? 50 : 150,
      width: small ? 150 : null,
      child: TeXView(
        child: TeXViewDocument(
          latex.transformedWithDollarSigns,
          style: small
              ? const TeXViewStyle.fromCSS('padding: 5px; font-size: 8px;')
              : const TeXViewStyle.fromCSS('padding: 5px;'),
        ),
      ),
    );
  }
}
