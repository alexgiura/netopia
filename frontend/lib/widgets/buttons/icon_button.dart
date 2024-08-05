import 'package:erp_frontend_v2/constants/style.dart';
import 'package:flutter/material.dart';

class CustomIconButton extends StatefulWidget {
  final IconData icon;

  final VoidCallback? onPressed;
  final Future<void> Function()? asyncOnPressed;

  const CustomIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.asyncOnPressed,
  });

  @override
  _CustomIconButtonState createState() => _CustomIconButtonState();
}

class _CustomIconButtonState extends State<CustomIconButton> {
  bool _isLoading = false;

  void _handlePressed() async {
    if (widget.asyncOnPressed != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        final asyncTask = widget.asyncOnPressed!.call();
        final delay = Future.delayed(const Duration(seconds: 1));

        await Future.wait([asyncTask, delay]);
      } finally {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        });
      }
    } else if (widget.onPressed != null) {
      widget.onPressed?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: _isLoading
          ? const Center(
              child: SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(CustomColor.textPrimary),
                ),
              ),
            )
          : Icon(
              widget.icon,
              color: CustomColor.textPrimary,
            ),
      onPressed: _isLoading ? null : _handlePressed,
    );
  }
}
