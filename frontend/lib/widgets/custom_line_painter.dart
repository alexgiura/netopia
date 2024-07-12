import 'package:flutter/material.dart';

class LinePainter extends CustomPainter {
  ///Index of the current item
  final int index;

  ///Total number of items
  final int itemCount;

  ///Color of the line
  final Color color;

  ///Width of the line
  final double? lineWidth;

  ///Stroke cap of the line
  final StrokeCap? strokeCap;

  ///Painting style of the line
  final PaintingStyle? paintingStyle;

  ///Stroke width of the line
  final double? strokeWith;

  LinePainter(
      {required this.index,
      required this.itemCount,
      required this.color,
      this.lineWidth,
      this.strokeCap,
      this.strokeWith,
      this.paintingStyle});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWith ?? 2.0
      ..style = paintingStyle ?? PaintingStyle.stroke
      ..strokeCap = strokeCap ?? StrokeCap.round;

    final path = Path();

    // Draw the main vertical line
    if (index + 1 != itemCount) {
      path.moveTo(size.width / 2, 0);
      path.lineTo(size.width / 2, size.height);
    }

    // Draw the short line at the bottom for each item except the last one
    path.moveTo(size.width * 0.5, size.height * 0.2);
    path.quadraticBezierTo(
        size.width * 0.5, size.height * 0.5, size.width, size.height / 2);

    // Draw a different line for the last item
    if (index + 1 == itemCount) {
      path.moveTo(size.width / 2, 0);
      path.lineTo(size.width / 2, size.height * 0.25);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
