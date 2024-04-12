import 'package:flutter/material.dart';

class LogoView extends StatelessWidget {
  final Size size;

  final bool transitionMode;

  const LogoView({
    super.key,
    required this.size,
    this.transitionMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final p = size.width / 1920.0;

    return Container(
      width: size.width,
      height: size.height,
      alignment: Alignment.topRight,
      child: AnimatedPadding(
        duration: const Duration(seconds: 2),
        curve: Curves.easeInOut,
        padding: transitionMode
            ? EdgeInsets.symmetric(
                vertical: (1080 - 750) / 2 * p,
                horizontal: (1920 - 750) / 2 * p,
              )
            : EdgeInsets.only(
                top: 25 * p,
                bottom: (1080 - 150 - 25) * p,
                left: (1920 - 150 - 25) * p,
                right: 25 * p,
              ),
        child: Image.asset(
          'assets/logo.png',
        ),
      ),
    );
  }
}
