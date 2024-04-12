import 'package:flutter/material.dart';
import 'package:integration_bee_helper/theme/theme_colors.dart';
import 'package:integration_bee_helper/widgets/triangle_painter.dart';

class ScoreView extends StatelessWidget {
  final String competitor1Name;
  final String competitor2Name;
  final List<int> scores;
  final int progressIndex;
  final Size size;

  const ScoreView({
    super.key,
    required this.competitor1Name,
    required this.competitor2Name,
    required this.scores,
    required this.progressIndex,
    required this.size,
  });

  Color getScoreColor(int score) {
    switch (score) {
      case 0:
        return ThemeColors.red;
      case 1:
        return ThemeColors.blue;
      case 2:
        return ThemeColors.yellow;
      default:
        return ThemeColors.grey;
    }
  }

  double getScoreDiameter(int score) {
    switch (score) {
      case 0:
      case 1:
      case 2:
        return 50;
      default:
        return 40;
    }
  }

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
              child: Row(
                children: [
                  Container(
                    height: 100 * p,
                    width: 350 * p,
                    color: ThemeColors.blue,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10 * p),
                      child: Center(
                        child: Text(
                          competitor1Name,
                          style: TextStyle(
                            color: ThemeColors.white,
                            fontSize: 50 * p,
                            fontWeight: FontWeight.bold,
                            shadows: const [
                              Shadow(
                                color: ThemeColors.black,
                                blurRadius: 1,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  TriangleView(
                    color: ThemeColors.blue,
                    height: 100 * p,
                    width: 20 * p,
                  ),
                  Expanded(
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (var score in scores)
                            Padding(
                              padding: EdgeInsets.all(5 * p),
                              child: Container(
                                width: getScoreDiameter(score) * p,
                                height: getScoreDiameter(score) * p,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: getScoreColor(score),
                                  boxShadow: [
                                    BoxShadow(
                                      color: getScoreColor(score),
                                      blurRadius: 5,
                                    )
                                  ],
                                ),
                                child: score == -1
                                    ? null
                                    : Icon(
                                        score == 0
                                            ? Icons.close_rounded
                                            : Icons.check_rounded,
                                        color: ThemeColors.white,
                                        size: 35 * p,
                                      ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  TriangleView(
                    orientation: TriangleOrientation.topLeft,
                    color: ThemeColors.yellow,
                    height: 100 * p,
                    width: 20 * p,
                  ),
                  Container(
                    height: 100 * p,
                    width: 350 * p,
                    color: ThemeColors.yellow,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10 * p),
                      child: Center(
                        child: Text(
                          competitor2Name,
                          style: TextStyle(
                            color: ThemeColors.white,
                            fontSize: 50 * p,
                            fontWeight: FontWeight.bold,
                            shadows: const [
                              Shadow(
                                color: ThemeColors.black,
                                blurRadius: 1,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
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
                      'Problem ${progressIndex + 1}',
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
