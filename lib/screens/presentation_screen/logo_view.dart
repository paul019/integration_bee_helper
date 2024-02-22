import 'package:flutter/material.dart';

class LogoView extends StatelessWidget {
  const LogoView({super.key});

  @override
  Widget build(BuildContext context) {
    final p = MediaQuery.of(context).size.width / 1920.0;

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
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
