import 'package:erp_frontend_v2/constants/style.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final IconData? icon;

  final VoidCallback? onPressed;
  const PrimaryButton(
      {super.key, required this.text, this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    if (icon != null) {
      return ElevatedButton.icon(
        style: CustomStyle.activeButton,
        label: Text(text, style: CustomStyle.primaryButtonText),
        icon: Icon(icon),
        onPressed: onPressed,
      );
    } else {
      return ElevatedButton(
        style: CustomStyle.activeButton,
        onPressed: onPressed,
        child: Text(text, style: CustomStyle.primaryButtonText),
      );
    }
  }
}
