import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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

String? validateCompanyCif(String v) {
  String cif = v.toUpperCase();
  cif = cif.indexOf('RO') > -1 ? cif.substring(2) : cif;
  cif = cif.replaceAll(RegExp(r'\s'), '');

  if (cif.length < 2 || cif.length > 10) {
    return 'Lungimea corectă fără RO, este între 2 și 10 caractere!';
  }

  if (int.tryParse(cif) == null) {
    return 'Nu este număr!';
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
    return 'CIF invalid!';
  }
  return null;
}

Widget buildTextWithLink({
  required String text,
  required String linkText,
  required Uri url,
  required TextStyle textStyle,
  required TextStyle linkStyle,
}) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        text,
        style: textStyle,
      ),
      InkWell(
        child: Text(
          linkText,
          style: linkStyle,
        ),
        onTap: () {
          launchUrl(url);
        },
      )
    ],
  );
}
