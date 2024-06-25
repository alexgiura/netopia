import 'package:erp_frontend_v2/constants/style.dart';
import 'package:flutter/material.dart';

enum SnackBarType { success, warning }

void showSnackBar(BuildContext context, String text, SnackBarType type) {
  TextStyle defaultStyle = CustomStyle.medium14(color: CustomColor.textPrimary);
  double textWidth = estimateTextWidth(text, defaultStyle);

  final RenderBox renderBox = context.findRenderObject() as RenderBox;
  final size = renderBox.size;

  Color backgroundColor;
  switch (type) {
    case SnackBarType.success:
      backgroundColor = CustomColor.green;
      break;
    case SnackBarType.warning:
      backgroundColor = CustomColor.warning;
      break;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      content: Container(
        child: Text(
          text,
          style: defaultStyle,
        ),
      ),
      width: 600,
      behavior: SnackBarBehavior.floating,
      backgroundColor: backgroundColor,
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height - 50,
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
