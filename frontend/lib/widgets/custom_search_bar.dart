import 'package:erp_frontend_v2/constants/sizes.dart';
import 'package:erp_frontend_v2/constants/style.dart';
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
    return TextFormField(
      cursorColor: CustomColor.textPrimary,
      decoration: InputDecoration(
          filled:
              true, // Use filled property to change interior color when widget.enabled is false
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14.00),
          constraints: const BoxConstraints.expand(
              height: CustomSize.textFormFieldHeight),
          hintText: hintText,
          hintStyle: CustomStyle.regular14(color: CustomColor.slate_500),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: visibleBorder == false
                  ? Colors.transparent
                  : CustomColor.slate_300,
              width: 1,
            ),
            borderRadius: CustomStyle.customBorderRadius,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: visibleBorder == false
                  ? Colors.transparent
                  : CustomColor.textPrimary,
            ),
            borderRadius: CustomStyle.customBorderRadius,
          ),
          prefixIcon:
              const Icon(Icons.search_rounded, color: CustomColor.slate_700),
          hoverColor: Colors.transparent),
      style: CustomStyle.medium14(),
      onChanged: (value) {
        onValueChanged!(value);
      },
    );

    // Old Code, please do not remove until be sure is working fine

    //     CustomTextField(
    //   initialValue: initialValue,
    //   borderVisible: visibleBorder,
    //   hintText: hintText,
    //   prefixWidget: const Icon(
    //     Icons.search_rounded,
    //     color: CustomColor.slate_700,
    //   ),
    //   onValueChanged: onValueChanged,
    //   hideErrortext: true,
    // );
  }
}
