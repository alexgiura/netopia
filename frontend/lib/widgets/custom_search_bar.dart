import 'package:erp_frontend_v2/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar(
      {super.key,
      this.hintText,
      this.onValueChanged,
      this.initialValue,
      this.visibleBorder});
  final String? hintText;
  final bool? visibleBorder;
  final String? initialValue;
  final Function(String)? onValueChanged;
  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      initialValue: initialValue,
      borderVisible: visibleBorder,
      hintText: hintText,
      prefixIcon: Icons.search_rounded,
      onValueChanged: onValueChanged,
      hideErrortext: true,
    );
  }
}
