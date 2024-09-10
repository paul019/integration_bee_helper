import 'package:flutter/material.dart';

class MaxWidthWrapper extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const MaxWidthWrapper({super.key, required this.child, this.maxWidth = 850});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
