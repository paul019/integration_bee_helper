import 'package:flutter/material.dart';
import 'package:integration_bee_helper/extensions/duration_extension.dart';
import 'package:integration_bee_helper/theme/theme_colors.dart';
import 'package:integration_bee_helper/widgets/triangle_painter.dart';

class TimerView extends StatelessWidget {
  final Duration timeLeft;
  final bool timerRed;
  final bool paused;
  final Size size;

  const TimerView({
    super.key,
    required this.timeLeft,
    required this.timerRed,
    required this.paused,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final p = size.width / 1920.0;

    return Container(
      width: size.width,
      height: size.height,
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 50 * p),
        child: Row(
          children: [
            Container(
              height: 100 * p,
              width: 250 * p,
              color: ThemeColors.blue,
              child: Padding(
                padding: EdgeInsets.only(left: 10 * p),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        timeLeft.timerString(),
                        style: TextStyle(
                          color:
                              timerRed ? ThemeColors.red : ThemeColors.yellow,
                          fontSize: 50 * p,
                        ),
                      ),
                      if (paused)
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0, left: 4.0),
                          child: Icon(
                            Icons.pause,
                            color:
                                timerRed ? ThemeColors.red : ThemeColors.yellow,
                            size: 50 * p,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            TriangleView(
              height: 100 * p,
              width: 20 * p,
            ),
          ],
        ),
      ),
    );
  }
}
