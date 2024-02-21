import 'package:flutter/material.dart';

class MaxWidthWrapper extends StatelessWidget {
  final Widget child;

  const MaxWidthWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 850),
        child: child,
      ),
    );
  }
}
