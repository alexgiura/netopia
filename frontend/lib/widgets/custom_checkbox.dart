import 'package:flutter/material.dart';

import '../constants/style.dart';

class CustomCheckbox extends StatelessWidget {
  const CustomCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.labelText,
  });
  final bool value;
  final String? labelText;

  final Function(bool) onChanged;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 20,
          width: 20,
          child: Checkbox(
              value: value,
              onChanged: (value) {
                onChanged(value!);
              }),
        ),
        labelText != null
            ? Padding(
                padding: EdgeInsets.only(left: 4),
                child: Text(
                  labelText!,
                  style: CustomStyle.labelText,
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
