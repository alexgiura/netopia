import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  String? _errorText = '';
  bool? _showError = false;

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              keyboardType: widget.keyboardType,
              controller: _textController,
              validator: (value) {
                String? validatorError = widget.validator?.call(value);
                if (validatorError != null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() {
                      _showError = true;
                      _errorText = validatorError;
                    });
                  });
                } else {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() {
                      _showError = false;
                      _errorText = '';
                    });
                  });
                }
                return validatorError;
              },
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
              cursorColor: CustomColor.textPrimary,
              cursorErrorColor: CustomColor.error,
              decoration: InputDecoration(
                errorStyle: TextStyle(
                  color: Colors.transparent,
                  fontSize: 0,
                ),

                isCollapsed: true,
                prefixText: '     ',
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
                    // 0 padding from left compansate with prefixText: otherwise error text is not allign on the left
                    const EdgeInsets.fromLTRB(0, 12, 16, 12),
                errorBorder: OutlineInputBorder(
                  borderRadius: CustomStyle.customBorderRadius,
                  borderSide: const BorderSide(color: CustomColor.error),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: CustomStyle.customBorderRadius,
                  borderSide: const BorderSide(color: CustomColor.error),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: widget.borderVisible == false
                        ? Colors.transparent
                        : CustomColor.slate_300,
                  ),
                  borderRadius: CustomStyle.customBorderRadius,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: CustomStyle.customBorderRadius,
                  borderSide: const BorderSide(color: CustomColor.textPrimary),
                ),

                hintText: widget.hintText,
                hintStyle: CustomStyle.regular14(color: CustomColor.slate_500),
                prefixIcon: widget.prefixWidget,
                prefixIconConstraints: BoxConstraints.tight(const Size(10, 60)),
                // errorStyle:
                //     CustomStyle.labelSemibold12(color: CustomColor.error),
                isDense: true,
                // helperText:
                //     '', // it's hack to avoid the error message to be shown
                errorMaxLines:
                    1, // ajustați numărul maxim de linii pentru mesajele de eroare
              ),
              onChanged: (value) {
                widget.onValueChanged!(value);
              },
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                _errorText!,
                style: CustomStyle.errorText,
              ),
            ),
            // (_showError == true && _errorText != null)
            //     ? Padding(
            //         padding: const EdgeInsets.only(bottom: 4),
            //         child: Text(
            //           _errorText!,
            //           style: CustomStyle.errorText,
            //         ),
            //       )
            //     : SizedBox.shrink()
          ],
        ),
      ],
    );
  }
}
