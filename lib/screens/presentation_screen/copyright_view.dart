import 'package:flutter/material.dart';
import 'package:integration_bee_helper/services/basic_services/intl_service.dart';

class CopyrightView extends StatelessWidget {
  final Size size;

  const CopyrightView({
    super.key,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final p = size.width / 1920.0;

    return Container(
      width: size.width,
      height: size.height,
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: EdgeInsets.only(left: 8.0 * p, bottom: 8.0 * p),
        child: Text(
          MyIntl.S.copyrightNotice('2024'),
          style: TextStyle(fontSize: 20 * p),
        ),
      ),
    );
  }
}
