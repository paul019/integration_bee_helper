import 'package:flutter/material.dart';
import 'package:integration_bee_helper/extensions/duration_extension.dart';
import 'package:integration_bee_helper/theme/theme_colors.dart';
import 'package:integration_bee_helper/widgets/triangle_painter.dart';

class TimerView extends StatelessWidget {
  final Duration timeLeft;

  const TimerView({
    super.key,
    required this.timeLeft,
  });

  @override
  Widget build(BuildContext context) {
    final p = MediaQuery.of(context).size.width / 1920.0;

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
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
                  child: Text(
                    timeLeft.timerString(),
                    style: TextStyle(
                      color: ThemeColors.yellow,
                      fontSize: 50 * p,
                    ),
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
