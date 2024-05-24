import 'package:flutter/material.dart';

class CopyrightView extends StatelessWidget {
  final Size size;

  const CopyrightView({
    super.key,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final p = size.width / 1920.0;

    return Container(
      width: size.width,
      height: size.height,
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: EdgeInsets.only(left: 8.0 * p, bottom: 8.0 * p),
        child: Text(
          'Software developed in Heidelberg by Paul Obernolte (MIT license, 2024)',
          style: TextStyle(fontSize: 20 * p),
        ),
      ),
    );
  }
}
