import 'package:flutter/material.dart';

class LogoView extends StatelessWidget {
  final Size size;

  const LogoView({
    super.key,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final p = size.width / 1920.0;

    return Container(
      width: size.width,
      height: size.height,
      alignment: Alignment.topRight,
      child: Padding(
        padding: EdgeInsets.all(25 * p),
        child: Image.asset(
          'assets/logo.png',
          width: 150 * p,
        ),
      ),
    );
  }
}
