import 'package:flutter/material.dart';

class IntegralCodeView extends StatelessWidget {
  final String code;
  final Size size;

  const IntegralCodeView({
    super.key,
    required this.code,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final p = size.width / 1920.0;

    return Container(
      width: size.width,
      height: size.height,
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0, bottom: 4.0),
        child: Text(
          code,
          style: TextStyle(fontSize: 20 * p),
        ),
      ),
    );
  }
}
