import 'package:erp_frontend_v2/constants/style.dart';
import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  final bool? hasBackIcon;

  const CustomHeader(
      {super.key, required this.title, this.subtitle, this.hasBackIcon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (hasBackIcon != null)
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(0),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
            ],
          ),
        Column(
          children: [
            Text(
              title,
              style: CustomStyle.medium40(),
            ),
            subtitle != null
                ? Text(
                    subtitle!,
                    style: CustomStyle.subtitleText,
                  )
                : SizedBox.shrink()
          ],
        ),
      ],
    );
  }
}
