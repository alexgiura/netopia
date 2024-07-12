import 'package:erp_frontend_v2/constants/style.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatefulWidget {
  final String text;
  final IconData? icon;
  final ButtonStyle? style;
  final VoidCallback? onPressed;
  final Future<void> Function()? asyncOnPressed;

  ///Optional font color to be used
  final Color? fontColor;

  const PrimaryButton({
    super.key,
    required this.text,
    this.icon,
    this.onPressed,
    this.asyncOnPressed,
    this.style,
    this.fontColor,
  });

  @override
  _PrimaryButtonState createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _isLoading = false;

  void _handlePressed() async {
    if (widget.asyncOnPressed != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        await widget.asyncOnPressed!.call();
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else if (widget.onPressed != null) {
      widget.onPressed?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: widget.style ?? CustomStyle.submitBlackButton,
      onPressed: _isLoading ? null : _handlePressed,
      child: _isLoading
          ? const Center(
              child: SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(CustomColor.textSecondary),
                ),
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.icon != null) Icon(widget.icon),
                if (widget.icon != null) const SizedBox(width: 8),
                Text(
                  widget.text,
                  style: CustomStyle.semibold14(
                      color: widget.fontColor ?? CustomColor.bgSecondary),
                ),
              ],
            ),
    );
  }
}
