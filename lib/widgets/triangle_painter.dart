import 'package:flutter/material.dart';
import 'package:integration_bee_helper/theme/theme_colors.dart';

enum TriangleOrientation { topLeft, topRight, bottomLeft, bottomRight }

class TrianglePainter extends CustomPainter {
  final TriangleOrientation orientation;
  final Color strokeColor;
  final PaintingStyle paintingStyle;
  final double strokeWidth;

  TrianglePainter({
    this.orientation = TriangleOrientation.bottomRight,
    this.strokeColor = Colors.black,
    this.strokeWidth = 3,
    this.paintingStyle = PaintingStyle.stroke,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = paintingStyle;

    canvas.drawPath(getTrianglePath(size.width, size.height), paint);
  }

  Path getTrianglePath(double x, double y) {
    switch (orientation) {
      case TriangleOrientation.topLeft:
        return Path()
          ..moveTo(x, 0)
          ..lineTo(x, y)
          ..lineTo(0, y)
          ..lineTo(x, 0);
      case TriangleOrientation.topRight:
        return Path()
          ..moveTo(0, 0)
          ..lineTo(x, y)
          ..lineTo(0, y)
          ..lineTo(0, 0);
      case TriangleOrientation.bottomLeft:
        return Path()
          ..moveTo(0, 0)
          ..lineTo(x, 0)
          ..lineTo(x, y)
          ..lineTo(0, 0);
      case TriangleOrientation.bottomRight:
        return Path()
          ..moveTo(0, 0)
          ..lineTo(x, 0)
          ..lineTo(0, y)
          ..lineTo(0, 0);
    }
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) {
    return oldDelegate.strokeColor != strokeColor ||
        oldDelegate.paintingStyle != paintingStyle ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

class TriangleView extends StatelessWidget {
  final TriangleOrientation orientation;
  final Color color;
  final double width;
  final double height;

  const TriangleView({
    super.key,
    this.orientation = TriangleOrientation.bottomRight,
    this.color = ThemeColors.blue,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: TrianglePainter(
        orientation: orientation,
        strokeColor: color,
        paintingStyle: PaintingStyle.fill,
      ),
      child: SizedBox(
        height: height,
        width: width,
      ),
    );
  }
}
