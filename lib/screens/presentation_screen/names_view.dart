import 'package:flutter/material.dart';
import 'package:integration_bee_helper/theme/theme_colors.dart';
import 'package:integration_bee_helper/widgets/triangle_painter.dart';

class NamesView extends StatelessWidget {
  final List<String> competitorNames;
  final String problemName;
  final Size size;

  const NamesView({
    super.key,
    required this.competitorNames,
    required this.problemName,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final p = size.width / 1920.0;

    return Container(
      width: size.width,
      height: size.height,
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15 * p),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 100 * p,
              color: ThemeColors.greyTransparent,
              alignment: Alignment.center,
              child: Text(
                competitorNames.join(' vs. '),
                style: TextStyle(
                  color: ThemeColors.black,
                  fontSize: 50 * p,
                  fontWeight: FontWeight.bold,
                  shadows: const [
                    Shadow(
                      color: ThemeColors.white,
                      blurRadius: 1,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 35 * p,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TriangleView(
                    orientation: TriangleOrientation.bottomLeft,
                    color: ThemeColors.greyTransparent,
                    width: 35 * p,
                    height: 35 * p,
                  ),
                  Container(
                    height: 35 * p,
                    width: 200 * p,
                    color: ThemeColors.greyTransparent,
                    alignment: Alignment.topCenter,
                    child: Text(
                      problemName,
                      style: TextStyle(
                        color: ThemeColors.black,
                        fontSize: 20 * p,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TriangleView(
                    orientation: TriangleOrientation.bottomRight,
                    color: ThemeColors.greyTransparent,
                    width: 35 * p,
                    height: 35 * p,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
