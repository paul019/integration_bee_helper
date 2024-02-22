import 'package:flutter/material.dart';

class BackgroundView extends StatelessWidget {
  const BackgroundView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Image.asset(
        'assets/background.png',
        fit: BoxFit.cover,
        opacity: const AlwaysStoppedAnimation(0.24),
      ),
    );
  }
}
