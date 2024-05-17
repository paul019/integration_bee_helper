import 'package:flutter/material.dart';

class VerticalSeparator extends StatelessWidget {
  const VerticalSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Text('|'),
    );
  }
}
