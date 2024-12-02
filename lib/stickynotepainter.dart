import 'package:flutter/material.dart';

class StickyNotePainter extends CustomPainter {
  const StickyNotePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint gradientPaint = _getGradientColor(size);

    _drawShadow(size, canvas);

    _drawStickyNote(canvas, size, gradientPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  void _drawStickyNote(Canvas canvas, Size size, Paint paint) {
    Path path = Path();
    double foldAmount = 0.12;

    path.moveTo(0, 0); //Starts at the top left of the widget

    path.lineTo(size.width, 0); //Draws the top line of the widget

    path.lineTo(size.width, size.height); //Draws the right line of the widget

    path.lineTo(size.width * 0.75, size.height); //Draws a bit of the lower line

    //Draw the sticky note fold with to curve lines
    path.quadraticBezierTo(size.width * foldAmount * 2, size.height,
        size.width * foldAmount, size.height - (size.height * foldAmount));
    path.quadraticBezierTo(
        0, size.height - (size.height * foldAmount * 1.5), 0, size.height / 4);

    path.lineTo(
        0, 0); //End the drawing by connecting to the initial starting point

    canvas.drawPath(path, paint);
  }

  void _drawShadow(Size size, Canvas canvas) {
    Rect rect = Rect.fromLTWH(12, 12, size.width - 24, size.height - 24);
    Path path = Path();
    path.addRect(rect);
    canvas.drawShadow(path, Colors.black, 12.0, true);
  }

  Paint _getGradientColor(Size size) {
    Paint paint = Paint();

    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    RadialGradient gradient = RadialGradient(
        colors: [_brightenColor(color), color],
        radius: 1.0,
        stops: const [0.5, 1.0],
        center: Alignment.bottomLeft);
    paint.shader = gradient.createShader(rect);
    return paint;
  }

  Color _brightenColor(Color c) {
    double brightnessFactor = 0.3;

    return Color.fromARGB(
        c.alpha,
        c.red + ((255 - c.red) * brightnessFactor).round(),
        c.green + ((255 - c.green) * brightnessFactor).round(),
        c.blue + ((255 - c.blue) * brightnessFactor).round());
  }
}
