import 'package:erp_frontend_v2/constants/style.dart';
import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final ButtonStyle? buttonStyle;
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
          icon: Icon(icon),
          onPressed: onPressed,
          label: Text(
            text,
            style: CustomStyle.secondaryButtonText,
          ));
    } else {
      return OutlinedButton(
          onPressed: onPressed,
          style: buttonStyle ?? CustomStyle.secondaryButton,
          child: Text(
            text,
            style: CustomStyle.secondaryButtonText,
          ));
    }
  }
}
