import 'package:flutter/material.dart';

class BottomWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Gradient
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    paint.shader = LinearGradient(
      colors: [
        Color(0xFF2E7D32), // dark green
        Color(0xFF66BB6A), // light green
        Color(0xFFE8F5E9), // very light
      ],
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
    ).createShader(rect);

    Path path = Path();

    // Starting point
    path.moveTo(0, size.height * 0.3);

    // First curve
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.0,
      size.width * 0.5,
      size.height * 0.2,
    );

    // Second curve
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.4,
      size.width,
      size.height * 0.2,
    );

    // Close shape
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);

    // OPTIONAL: second lighter wave (layered effect)
    final paint2 = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.white.withValues(alpha: 0.3),
          Colors.transparent,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(rect);

    Path path2 = Path();
    path2.moveTo(0, size.height * 0.5);

    path2.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.2,
      size.width * 0.6,
      size.height * 0.5,
    );

    path2.quadraticBezierTo(
      size.width * 0.85,
      size.height * 0.7,
      size.width,
      size.height * 0.5,
    );

    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();

    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}