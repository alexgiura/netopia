import 'package:erp_frontend_v2/constants/style.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    Key? key,
    required this.text,
    this.icon,
    required this.onPressed,
    this.textStyle,
    this.style,
  }) : super(key: key);
  final String text;
  final IconData? icon;
  final ButtonStyle? style;
  final TextStyle? textStyle;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    if (icon != null) {
      return ElevatedButton.icon(
        style: style ?? CustomStyle.activeButton,
        label: Text(text, style: textStyle ?? CustomStyle.primaryButtonText),
        icon: Icon(icon),
        onPressed: onPressed,
      );
    } else {
      return ElevatedButton(
        style: style ?? CustomStyle.activeButton,
        onPressed: onPressed,
        child: Text(text, style: textStyle ?? CustomStyle.primaryButtonText),
      );
    }
  }
}
