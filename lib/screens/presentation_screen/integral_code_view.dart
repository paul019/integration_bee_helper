import 'package:flutter/material.dart';

class IntegralCodeView extends StatelessWidget {
  final String code;

  const IntegralCodeView({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    //final p = MediaQuery.of(context).size.width / 1920.0;

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0, bottom: 4.0),
        child: Text(
          code,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
