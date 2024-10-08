import 'dart:math';

import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

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

String? validateEmail(BuildContext context, String email) {
  // Regular expression for validating an email address
  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  if (!emailRegex.hasMatch(email)) {
    return 'error_email_format'.tr(context);
  }

  return null; // Email is valid
}

String? validateCompanyCif(BuildContext context, String v) {
  String cif = v.toUpperCase();
  cif = cif.indexOf('RO') > -1 ? cif.substring(2) : cif;
  cif = cif.replaceAll(RegExp(r'\s'), '');

  if (cif.length < 2 || cif.length > 10) {
    return 'wrong_company_vat_number'.tr(context);
  }

  if (int.tryParse(cif) == null) {
    return 'wrong_company_vat_number'.tr(context);
  }

  const testKey = '753217532';
  final controlNumber = int.parse(cif.substring(cif.length - 1));
  cif = cif.substring(0, cif.length - 1);

  while (cif.length != testKey.length) {
    cif = '0' + cif;
  }

  int sum = 0;
  int i = cif.length;

  while (i-- > 0) {
    sum = sum + int.parse(cif[i]) * int.parse(testKey[i]);
  }

  int calculatedControlNumber = (sum * 10) % 11;

  if (calculatedControlNumber == 10) {
    calculatedControlNumber = 0;
  }

  if (controlNumber != calculatedControlNumber) {
    return 'wrong_company_vat_number'.tr(context);
  }
  return null;
}

String truncateToDecimals(double? number, [int decimals = 2]) {
  if (number == null) {
    return 0.toStringAsFixed(decimals);
  }
  double factor = pow(10, decimals).toDouble();
  double truncated = (number * factor).truncateToDouble() / factor;
  return truncated.toStringAsFixed(decimals);
}

formatPrice(double? price) => ' ${truncateToDecimals(price, 2)} RON';
formatDate(DateTime date) => DateFormat.yMd().format(date);

Future<void> launch(String url, {bool isNewTab = true}) async {
  await launchUrl(
    Uri.parse(url),
    webOnlyWindowName: isNewTab ? '_blank' : '_self',
  );
}
