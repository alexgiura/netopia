import 'package:erp_frontend_v2/constants/style.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final ButtonStyle? style;
  final VoidCallback? onPressed;
  const PrimaryButton(
      {super.key,
      required this.text,
      this.icon,
      required this.onPressed,
      this.style});

  @override
  Widget build(BuildContext context) {
    if (icon != null) {
      return ElevatedButton.icon(
        style: style ?? CustomStyle.submitBlackButton,
        label: Text(text,
            style:
                CustomStyle.buttonSemibold14(color: CustomColor.textSecondary)),
        icon: Icon(icon),
        onPressed: onPressed,
      );
    } else {
      return ElevatedButton(
        style: style ?? CustomStyle.submitBlackButton,
        onPressed: onPressed,
        child: Text(text,
            style:
                CustomStyle.buttonSemibold14(color: CustomColor.textSecondary)),
      );
    }
  }
}
