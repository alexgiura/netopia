import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text, TextStyle style) {
  double textWidth = estimateTextWidth(text, style);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      content: Container(
        child: Text(
          text,
          style: style,
        ),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.green,
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height - 50,
        right: (MediaQuery.of(context).size.width - 250 - textWidth - 32) / 2,
        left: (MediaQuery.of(context).size.width - 250 - textWidth - 32) / 2,
      ),
    ),
  );
}

double estimateTextWidth(String text, TextStyle style) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: TextDirection.ltr,
  )..layout();

  return textPainter.width;
}
