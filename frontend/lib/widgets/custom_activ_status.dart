import 'package:erp_frontend_v2/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class CustomActiveStatus extends StatelessWidget {
  final bool isActive;

  const CustomActiveStatus({
    Key? key,
    required this.isActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isActive) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 24,
      width: 24,
      decoration: const ShapeDecoration(
        shape: CircleBorder(),
        color: CustomColor.accentColor,
      ),
      child: const Center(
        child: Icon(
          Symbols.check_rounded,
          size: 20,
          fill: 1,
          weight: 600,
          opticalSize: 24,
        ),
      ),
    );
  }
}
