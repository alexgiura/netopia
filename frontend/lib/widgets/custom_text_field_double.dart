import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFieldFloat extends StatefulWidget {
  const CustomTextFieldFloat({
    Key? key,
    required this.onValueChanged,
    required this.initialValue,
    this.enabled = true,
    this.readonly,
    this.maxDecimalNumber = 2,
    this.minDecimalNumber = 2,
  }) : super(key: key);

  final Function(double) onValueChanged;
  final double initialValue;
  final bool enabled;
  final bool? readonly;
  final int? maxDecimalNumber;
  final int? minDecimalNumber;

  @override
  State<CustomTextFieldFloat> createState() => _CustomTextFieldFloatState();
}

class _CustomTextFieldFloatState extends State<CustomTextFieldFloat> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    // _controller.text =
    //     widget.initialValue.toStringAsFixed(widget.minDecimalNumber!);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  String formatValue(double value) {
    int maxDecimals = widget.maxDecimalNumber ?? 2;
    int minDecimals = widget.minDecimalNumber ?? 2;
    String valueString = value.toString();

    // Extract the decimal part
    List<String> parts = valueString.split('.');
    if (parts.length == 2) {
      // Has a decimal part
      String decimalPart = parts[1];
      if (decimalPart.length > maxDecimals) {
        // Truncate to max decimals
        return value.toStringAsFixed(maxDecimals);
      } else if (decimalPart.length < minDecimals) {
        // Pad to min decimals
        return value.toStringAsFixed(minDecimals);
      }
    } else {
      // No decimal part, pad to min decimals
      return value.toStringAsFixed(minDecimals);
    }
    return valueString; // Return as is if within constraints
  }

  @override
  Widget build(BuildContext context) {
    if (widget.initialValue == 0) {
      _controller.text = '';
    } else {
      _controller.text = formatValue(widget.initialValue);
    }

    return TapRegion(
      child: TextFormField(
        readOnly: widget.readonly ?? false,
        focusNode: _focus,
        textDirection: TextDirection.ltr,
        controller: _controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration:
            const InputDecoration(border: InputBorder.none, hintText: '0.00'),
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(
              r'^-?(\d+)?\.?\d{0,' + widget.maxDecimalNumber.toString() + '}'))
        ],
      ),
      onTapOutside: (event) {
        if (_focus.hasFocus) {
          double? parsedValue = double.tryParse(_controller.text);
          if (parsedValue != null) {
            _controller.text = formatValue(parsedValue);
            widget.onValueChanged(parsedValue);
          } else {
            _controller.text = '';
            widget.onValueChanged(0);
          }
        }
      },
    );
  }
}
