import 'dart:math';

import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CustomRadioButton extends StatefulWidget {
  /// The text to display above the radio buttons. Example: 'Select an option'
  final String text;

  /// The options to display as radio buttons. Example: ['Option 1', 'Option 2']
  final List<String> options;

  /// The initial value of the radio button. If null, no radio button will be selected.
  final bool? initialValue;

  /// The function to call when the radio button is changed. The value of the selected radio button is passed as a parameter.
  final void Function(String? value) onChanged;

  /// The value of the currently selected radio button. `groupValue` must be unique for each group of radio buttons.
  final String groupValue;

  /// The error text to display when the radio button is invalid. If null, the default error text is displayed.
  final String? errorText;

  /// The direction of the radio buttons. Either horizontal or vertical. If null, the default direction is horizontal.
  final Axis? direction;

  /// The style of the text above the radio buttons. If null, the default style is used.
  final TextStyle? textStyle;

  /// The function to validate the radio button. Example: (value) => value == null ? 'This field is required' : null
  final String? Function(String?)? validator;

  const CustomRadioButton({
    Key? key,
    required this.text,
    this.textStyle,
    required this.options,
    required this.onChanged,
    required this.groupValue,
    this.initialValue,
    this.errorText,
    this.direction,
    this.validator,
  }) : super(key: key);

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
                children: [
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
            children: [
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
