import 'package:flutter/material.dart';

class BackgroundView extends StatelessWidget {
  final Size size;

  const BackgroundView({
    super.key,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Image.asset(
        'assets/images/background.png',
        fit: BoxFit.cover,
        opacity: const AlwaysStoppedAnimation(0.24),
      ),
    );
  }
}
