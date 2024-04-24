import 'package:erp_frontend_v2/constants/style.dart';
import 'package:flutter/material.dart';

class TertiaryButton extends StatelessWidget {
  final String text;
  final IconData? icon;

  final VoidCallback? onPressed;
  const TertiaryButton(
      {super.key, required this.text, this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    if (icon != null) {
      return TextButton.icon(
        style: CustomStyle.tertiaryButton,
        label: Text(
          text,
          style: CustomStyle.tertiaryButtonText,
        ),
        icon: Icon(
          icon,
        ),
        onPressed: onPressed,
      );
    } else {
      return TextButton(
        style: CustomStyle.tertiaryButton,
        onPressed: onPressed,
        child: Text(text, style: CustomStyle.tertiaryButtonText),
      );
    }
  }
}
