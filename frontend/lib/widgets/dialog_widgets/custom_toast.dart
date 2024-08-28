import 'package:erp_frontend_v2/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

enum ToastType { success, warning, error }

void showToast(String text, ToastType type) {
  toastification.showCustom(
    autoCloseDuration: const Duration(seconds: 3),
    alignment: Alignment.topCenter,
    builder: (BuildContext context, ToastificationItem holder) {
      return Transform.translate(
        offset:
            const Offset(0, -24), // Adjust the value to move the toast higher
        child: IntrinsicWidth(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: CustomStyle.customBorderRadiusSmall,
              color: CustomColor.bgSecondary,
            ),
            height: 40,
            child: ClipRRect(
              borderRadius: CustomStyle.customBorderRadiusSmall,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    color: type == ToastType.error
                        ? CustomColor.error.withOpacity(0.1)
                        : type == ToastType.warning
                            ? CustomColor.warning.withOpacity(0.1)
                            : CustomColor.green.withOpacity(0.1),
                    width: 40,
                    child: Center(
                      child: Icon(
                        type == ToastType.error
                            ? Icons.cancel_outlined
                            : type == ToastType.warning
                                ? Icons.error_outline_rounded
                                : Icons.check_circle_outline_rounded,
                        size: 20,
                        color: type == ToastType.error
                            ? CustomColor.error
                            : type == ToastType.warning
                                ? CustomColor.warning
                                : CustomColor.green,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(text, style: CustomStyle.semibold14()),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
