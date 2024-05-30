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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: CustomColor.textPrimary,
        ),
      ),
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.050,
      child: InkWell(
          onTap: onPressed,
          child: Center(
            child: Text(
              text,
              style: CustomStyle.buttonSemibold14(
                color: CustomColor.textPrimary,
              ),
            ),
          )),
    );
  }
}
