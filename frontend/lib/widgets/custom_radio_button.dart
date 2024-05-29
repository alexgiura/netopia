import 'dart:math';

import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CustomRadioButton extends StatefulWidget {
  const CustomRadioButton({
    Key? key,
    required this.text,
    this.textStyle,
    required this.options,
    required this.onChanged,
    required this.groupValue,
    this.errorText,
    this.direction,
    this.validator,
  }) : super(key: key);
  final String text;
  final List<String> options;
  final void Function(String? value) onChanged;
  final String groupValue;
  final String? errorText;
  final Axis? direction;
  final TextStyle? textStyle;
  final String? Function(String?)? validator;

  @override
  State<CustomRadioButton> createState() => _CustomRadioButtonState();
}

class _CustomRadioButtonState extends State<CustomRadioButton> {
  String? _errorText;

  void _validate(String? value) {
    setState(() {
      if (widget.validator != null) {
        _errorText = widget.validator!(value);
      } else if (value == null || value.isEmpty) {
        _errorText = widget.errorText ?? 'this_field_is_required'.tr(context);
      } else {
        _errorText = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: widget.direction == Axis.horizontal
                  ? _buildHorizontal(
                      context: context,
                      text: widget.text,
                      options: widget.options,
                      onChanged: (val) {
                        widget.onChanged(val);
                        _validate(val);
                      },
                      groupValue: widget.groupValue,
                    )
                  : _buildVertical(
                      context: context,
                      text: widget.text,
                      options: widget.options,
                      onChanged: (val) {
                        widget.onChanged(val);
                        _validate(val);
                      },
                      groupValue: widget.groupValue,
                    ),
            ),
          ],
        ),
        if (_errorText != null)
          Text(
            _errorText!,
            style: CustomStyle.errorText,
          ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            RichText(
              text: TextSpan(
                text: text,
                style: widget.textStyle,
                children: const [
                  TextSpan(
                    text: ' *',
                    style: CustomStyle.errorText,
                  ),
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
                  Text(option.tr(context)),
                ],
              ),
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
        RichText(
          text: TextSpan(
            text: text,
            style: widget.textStyle,
            children: const [
              TextSpan(
                text: ' *',
                style: CustomStyle.errorText,
              ),
            ],
          ),
        ),
        Gap(context.height01),
        for (var option in options)
          Row(
            children: [
              Text(option),
              Radio(
                activeColor: CustomColor.textPrimary,
                value: option,
                groupValue: groupValue,
                onChanged: (value) => onChanged(value),
              ),
            ],
          ),
      ],
    );
  }
}
