import 'package:flutter/material.dart';

class TextBubble extends StatelessWidget {
  final Color? color;
  final String text;

  const TextBubble({super.key, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(100),
        ),
        color: color,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 2.0,
          horizontal: 6.0,
        ),
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
