import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum StatusType { success, warning, error }

class CustomStatusChip extends StatelessWidget {
  final StatusType type;
  final String label;

  const CustomStatusChip({super.key, required this.type, required this.label});

  Color _getBackgroundColor() {
    switch (type) {
      case StatusType.warning:
        return CustomColor.warning.withOpacity(0.1);
      case StatusType.error:
        return CustomColor.error.withOpacity(0.1);
      default:
        return CustomColor.green.withOpacity(0.1);
    }
  }

  Color _getTextColor() {
    switch (type) {
      case StatusType.warning:
        return CustomColor.warning;
      case StatusType.error:
        return CustomColor.error;
      default:
        return CustomColor.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      height: 28,
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Center(
        child: Text(
          label,
          style: CustomStyle.semibold14(color: _getTextColor()),
        ),
      ),
    );
  }
}
