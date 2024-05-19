import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:integration_bee_helper/services/basic_services/latex_transformer.dart';

class LatexView extends StatelessWidget {
  final String latex;

  const LatexView({super.key, required this.latex});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: TeXView(
        child: TeXViewDocument(
          LatexTransformer.transform(latex),
          style: const TeXViewStyle.fromCSS('padding: 5px;'),
        ),
      ),
    );
  }
}
