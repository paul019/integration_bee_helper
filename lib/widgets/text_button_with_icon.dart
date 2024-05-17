import 'package:flutter/material.dart';

class TextButtonWithIcon extends StatelessWidget {
  final void Function() onPressed;
  final Widget child;
  final IconData icon;

  const TextButtonWithIcon({
    super.key,
    required this.onPressed,
    required this.child,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 4.0),
          child,
        ],
      ),
    );
  }
}
