import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CustomRadioButton extends StatelessWidget {
  const CustomRadioButton({
    super.key,
    required this.text,
    required this.options,
    required this.onChanged,
    this.errorText,
    this.direction,
  });
  final String text;
  final List<String> options;
  final void Function(String value) onChanged;
  final String? errorText;
  final Axis? direction;

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
                  onChanged: (val) => onChanged,
                )
              : _buildVertical(
                  context: context,
                  text: text,
                  options: options,
                  onChanged: (val) => onChanged),
        ]))
      ],
    );
  }

  Widget _buildHorizontal(
      {required BuildContext context,
      required String text,
      required List<String> options,
      required void Function(String? value) onChanged}) {
    return Row(
      children: [
        Text(text),
        Gap(context.width01),
        for (var option in options)
          Row(
            children: [
              Text(option),
              Radio(
                  activeColor: CustomColor.textPrimary,
                  value: option,
                  groupValue: option,
                  onChanged: (value) => onChanged(value)),
            ],
          ),
      ],
    );
  }

  Widget _buildVertical(
      {required BuildContext context,
      required String text,
      required List<String> options,
      required void Function(String? value) onChanged}) {
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
                  value: option,
                  groupValue: option,
                  onChanged: (value) => onChanged(value)),
            ],
          ),
      ],
    );
  }
}
