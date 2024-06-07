import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:flutter/material.dart';

String formatNumber(double value) {
  if ((value * 1000) % 10 != 0) {
    return value.toStringAsFixed(3);
  } else {
    return value.toStringAsFixed(2);
  }
}

String? validatePassword(BuildContext context, String password) {
  // At least 6 characters
  if (password.length < 6) {
    return 'error_password_length'.tr(context);
  }

  // At least 1 uppercase letter
  if (!RegExp(r'[A-Z]').hasMatch(password)) {
    return 'error_password_uppercase'.tr(context);
  }

  // At least 1 lowercase letter
  if (!RegExp(r'[a-z]').hasMatch(password)) {
    return 'error_password_lowercase'.tr(context);
  }

  // At least 1 number
  if (!RegExp(r'[0-9]').hasMatch(password)) {
    return 'error_password_number'.tr(context);
  }

  // At least 1 special character
  if (!RegExp(r'[!@#$%^&*(),.?":{}|<>_]').hasMatch(password)) {
    return 'error_password_special'.tr(context);
  }

  // No whitespace characters
  if (RegExp(r'\s').hasMatch(password)) {
    return 'error_password_whitespace'.tr(context);
  }

  return null; // Password is valid
}

bool isValidEmail(String email) {
    // Regular expression for validating an email address
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }