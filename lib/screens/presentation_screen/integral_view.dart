import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';

class IntegralView extends StatelessWidget {
  final String latex;
  final Size size;

  const IntegralView({
    super.key,
    required this.latex,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    //final p = size.width / 1920.0;

    return Container(
      width: size.width,
      height: size.height,
      alignment: Alignment.center,
      child: TeXView(
        child: TeXViewDocument(
          '\$\$$latex\$\$',
          style: const TeXViewStyle.fromCSS('padding: 5px; font-size: 50px'),
        ),
      ),
    );
  }
}
