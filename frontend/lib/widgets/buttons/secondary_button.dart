import 'package:erp_frontend_v2/constants/style.dart';
import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;
  const SecondaryButton(
      {super.key, required this.text, this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    if (icon != null) {
      return OutlinedButton.icon(
          style: CustomStyle.secondaryButton,
          icon: Icon(icon),
          onPressed: onPressed,
          label: Text(
            text,
            style: CustomStyle.secondaryButtonText,
          ));
    } else {
      return OutlinedButton(
          onPressed: onPressed,
          style: CustomStyle.secondaryButton,
          child: Text(
            text,
            style: CustomStyle.secondaryButtonText,
          ));
    }
  }
}
