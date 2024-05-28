import 'dart:math';

import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CustomRadioButton extends StatelessWidget {
  const CustomRadioButton({
    Key? key,
    required this.text,
    this.textStyle,
    required this.options,
    required this.onChanged,
    required this.groupValue,
    this.errorText,
    this.direction,
  }) : super(key: key);
  final String text;
  final List<String> options;
  final void Function(String? value) onChanged;
  final String groupValue;
  final String? errorText;
  final Axis? direction;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
            child: Row(children: [
          direction == Axis.horizontal
              ? _buildHorizontal(
                  context: context,
                  text: text,
                  options: options,
                  onChanged: (val) => onChanged(val),
                  groupValue: groupValue,
                )
              : _buildVertical(
                  context: context,
                  text: text,
                  options: options,
                  onChanged: (val) => onChanged,
                  groupValue: groupValue,
                ),
        ]))
      ],
    );
  }

  Widget _buildHorizontal({
    required BuildContext context,
    required String text,
    required List<String> options,
    required void Function(String? value) onChanged,
    required String groupValue,
  }) {
    return Row(
      children: [
        RichText(
          text: TextSpan(
            text: text,
            style: textStyle,
            children: [
              TextSpan(
                text: ' *',
                style: CustomStyle.errorText,
              )
            ],
          ),
        ),
        Gap(context.width01),
        for (var option in options)
          Row(
            children: [
              Radio(
                  activeColor: CustomColor.textPrimary,
                  value: option.toString(),
                  groupValue: groupValue,
                  onChanged: (value) => onChanged(value)),
              Text(option),
            ],
          ),
      ],
    );
  }

  Widget _buildVertical({
    required BuildContext context,
    required String text,
    required List<String> options,
    required void Function(String? value) onChanged,
    required String groupValue,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text),
        Gap(context.height01),
        for (var option in options)
          Row(
            children: [
              Text(option),
              Radio(
                activeColor: CustomColor.textPrimary,
                value: groupValue,
                groupValue: groupValue,
                onChanged: (value) => print(value),
              )
            ],
          ),
      ],
    );
  }
}
