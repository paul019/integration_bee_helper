import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:integration_bee_helper/models/agenda_item_model/score.dart';
import 'package:integration_bee_helper/theme/theme_colors.dart';
import 'package:integration_bee_helper/widgets/triangle_painter.dart';

class ScoreView extends StatelessWidget {
  final String competitor1Name;
  final String competitor2Name;
  final List<Score> scores;
  final int totalProgress;
  final String problemName;
  final Size size;
  final ConfettiController competitor1ConfettiController;
  final ConfettiController competitor2ConfettiController;

  const ScoreView({
    super.key,
    required this.competitor1Name,
    required this.competitor2Name,
    required this.scores,
    required this.totalProgress,
    required this.problemName,
    required this.size,
    required this.competitor1ConfettiController,
    required this.competitor2ConfettiController,
  });

  Color getScoreColor(Score score) {
    switch (score) {
      case Score.tie:
        return ThemeColors.red;
      case Score.competitor1:
        return ThemeColors.blue;
      case Score.competitor2:
        return ThemeColors.yellow;
      case Score.notSetYet:
        return ThemeColors.grey;
    }
  }

  double getScoreDiameter(int index) {
    if (index == totalProgress) {
      return 50;
    } else {
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
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Text(
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
                          ConfettiWidget(
                            confettiController: competitor1ConfettiController,
                            blastDirection: -pi / 4,
                            shouldLoop: true,
                            colors: const [ThemeColors.blue],
                            maxBlastForce: p * 100,
                            minBlastForce: p * 80,
                            minimumSize: Size(10 * p, 10 * p),
                            maximumSize: Size(50 * p, 50 * p),
                          ),
                        ],
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
                          for (var i = 0; i < scores.length; i++)
                            Padding(
                              padding: EdgeInsets.all(5 * p),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 500),
                                width: getScoreDiameter(i) * p,
                                height: getScoreDiameter(i) * p,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: getScoreColor(scores[i]),
                                  boxShadow: [
                                    BoxShadow(
                                      color: getScoreColor(scores[i]),
                                      blurRadius: 5,
                                    )
                                  ],
                                ),
                                child: scores[i] == Score.notSetYet
                                    ? null
                                    : Icon(
                                        scores[i] == Score.tie
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
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Text(
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
                          ConfettiWidget(
                            confettiController: competitor2ConfettiController,
                            blastDirection: -3 * pi / 4,
                            shouldLoop: true,
                            colors: const [ThemeColors.yellow],
                            maxBlastForce: p * 100,
                            minBlastForce: p * 80,
                            minimumSize: Size(10 * p, 10 * p),
                            maximumSize: Size(50 * p, 50 * p),
                          ),
                        ],
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
