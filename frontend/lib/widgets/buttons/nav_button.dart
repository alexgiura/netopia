import 'package:erp_frontend_v2/constants/style.dart';
import 'package:flutter/material.dart';

class CustomNavButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String? text;

  const CustomNavButton(
      {Key? key, required this.onTap, required this.icon, this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      overlayColor: const MaterialStatePropertyAll(
        Colors.transparent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: const ShapeDecoration(
              shape: CircleBorder(),
              color: CustomColor.accentNeutral,
            ),
            child: Center(
              child: Icon(
                icon,
                size: 24,
              ),
            ),
          ),
          if (text != null)
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text(
                text!,
                style: CustomStyle.medium16(),
              ),
            )
        ],
      ),
      onTap: () {
        onTap();
      },
    );
  }
}
