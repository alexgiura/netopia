import 'package:erp_frontend_v2/constants/style.dart';
import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  const SubmitButton({
    super.key,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: CustomColor.textPrimary),
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.048,
      child: InkWell(
          onTap: onPressed,
          child: Center(
            child: Text(
              text,
              style: CustomStyle.buttonSemibold14(
                color: CustomColor.textSecondary,
              ),
            ),
          )),
    );
  }
}
