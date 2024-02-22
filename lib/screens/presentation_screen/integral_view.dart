import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';

class IntegralView extends StatelessWidget {
  final String latex;

  const IntegralView({super.key, required this.latex});

  @override
  Widget build(BuildContext context) {
    //final p = MediaQuery.of(context).size.width / 1920.0;

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
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
