import 'package:erp_frontend_v2/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class CustomEditButton extends StatelessWidget {
  final VoidCallback onTap;

  const CustomEditButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      width: 32,
      decoration: const ShapeDecoration(
        shape: CircleBorder(),
        color: CustomColor.accentNeutral, // Circle fill color
      ),
      child: Material(
        shape: const CircleBorder(),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(
              16), // Half of the total size to create a circle
          onTap: () {
            onTap();
          },
          child: const Center(
            child: Icon(
              Symbols.edit_rounded,
              size: 20,
              fill: 0,
              weight: 400,
              opticalSize: 24,
            ),
          ),
        ),
      ),
    );
  }
}
