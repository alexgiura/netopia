import 'package:erp_frontend_v2/constants/style.dart';
import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final ButtonStyle? buttonStyle;
  final VoidCallback? onPressed;
  const SecondaryButton(
      {super.key,
      required this.text,
      this.icon,
      required this.onPressed,
      this.buttonStyle});

  @override
  Widget build(BuildContext context) {
    if (icon != null) {
      return OutlinedButton.icon(
        style: buttonStyle ?? CustomStyle.secondaryButton,
        label: Text(text, style: CustomStyle.secondaryButtonText),
        icon: Icon(icon),
        onPressed: onPressed,
      );
    } else {
      return OutlinedButton(
        style: buttonStyle ?? CustomStyle.secondaryButton,
        onPressed: onPressed,
        child: Text(text, style: CustomStyle.secondaryButtonText),
      );
    }
  }
}
