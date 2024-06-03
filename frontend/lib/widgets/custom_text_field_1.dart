import 'package:erp_frontend_v2/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../constants/style.dart';

class CustomTextField1 extends StatefulWidget {
  const CustomTextField1({
    Key? key,
    this.labelText,
    this.hintText,
    this.onValueChanged,
    this.initialValue,
    this.readOnly,
    this.prefixWidget,
    this.borderVisible,
    this.obscureText,
    this.keyboardType = TextInputType.text,
    this.required = false,
    this.validator,
    this.autovalidateMode,
  }) : super(key: key);

  final String? labelText;
  final String? hintText;
  final Widget? prefixWidget;
  final Function(String)? onValueChanged;
  final String? initialValue;
  final bool? readOnly;
  final bool? borderVisible;
  final bool? obscureText;
  final TextInputType keyboardType;
  final bool required;
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;
  @override
  State<CustomTextField1> createState() => CustomTextField1State();
}

class CustomTextField1State extends State<CustomTextField1> {
  final TextEditingController _textController = TextEditingController();
  String? lastInitialValue;
  bool? _obscureText = true;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      lastInitialValue = widget.initialValue!;
      _textController.text = widget.initialValue!;
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.initialValue != null) {
      if (widget.initialValue != lastInitialValue) {
        lastInitialValue = widget.initialValue!;
        _textController.text = widget.initialValue!;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null)
          RichText(
            text: TextSpan(
              text: widget.labelText,
              children: [
                if (widget.required)
                  TextSpan(
                    text: ' *',
                    style: CustomStyle.errorText,
                  ),
              ],
            ),
          ),
        const Gap(8.0),
        Column(
          children: [
            TextFormField(
              keyboardType: widget.keyboardType,
              controller: _textController,
              validator: widget.validator,
              obscureText: widget.keyboardType == TextInputType.visiblePassword
                  ? _obscureText!
                  : false,
              autovalidateMode:
                  widget.autovalidateMode ?? AutovalidateMode.onUserInteraction,
              onTapOutside: (focusNode) {
                setState(() {
                  widget.keyboardType == TextInputType.visiblePassword
                      ? _obscureText = true
                      : _obscureText = false;
                });
              },
              decoration: InputDecoration(
                alignLabelWithHint: true,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                suffixIcon: widget.obscureText != null
                    ? IconButton(
                        icon: Icon(
                          _obscureText == false
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: CustomColor.slate_500,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText!;
                          });
                        },
                      )
                    : null,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                errorBorder: OutlineInputBorder(
                  borderRadius: CustomStyle.customBorderRadius,
                  borderSide:
                      const BorderSide(color: CustomColor.redErrorRequired),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: CustomStyle.customBorderRadius,
                  borderSide:
                      const BorderSide(color: CustomColor.redErrorRequired),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: CustomStyle.customBorderRadius,
                  borderSide:
                      const BorderSide(color: CustomColor.light, width: 0.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: CustomStyle.customBorderRadius,
                  borderSide: const BorderSide(color: CustomColor.active),
                ),
                hintText: widget.hintText,
                hintStyle: CustomStyle.regular14(color: CustomColor.slate_500),
                prefixIcon: widget.prefixWidget,
                prefixIconConstraints: BoxConstraints.tight(const Size(10, 60)),
                errorStyle: CustomStyle.errorText,
                isDense: true,
                helperText:
                    ' ', // it's hack to avoid the error message to be shown
                errorMaxLines:
                    1, // ajustați numărul maxim de linii pentru mesajele de eroare
              ),
            ),
          ],
        ),
      ],
    );
  }
}
