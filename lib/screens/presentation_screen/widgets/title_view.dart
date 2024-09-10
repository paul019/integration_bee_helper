import 'package:flutter/material.dart';
import 'package:integration_bee_helper/theme/theme_colors.dart';

class TitleView extends StatelessWidget {
  final String title;
  final Size size;

  const TitleView({
    super.key,
    required this.title,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final p = size.width / 1920.0;

    return Container(
      width: size.width,
      height: size.height,
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 50 * p),
        child: SizedBox(
          height: 100 * p,
          child: Center(
            child: Text(
              title.toUpperCase(),
              style: TextStyle(
                color: ThemeColors.black,
                fontSize: 35 * p,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
