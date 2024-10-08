import 'package:erp_frontend_v2/constants/sizes.dart';
import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:flutter/material.dart';

import '../constants/style.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    Key? key,
    this.labelText,
    this.hintText,
    this.onValueChanged,
    this.initialValue,
    this.enabled = true,
    this.errorText,
    this.validator,
    this.visible,
    this.onTap,
    this.readOnly,
    this.prefixWidget,
    this.borderVisible,
    this.hideErrortext,
    this.obscureText,
    this.keyboardType = TextInputType.text,
    this.expand = true,
    this.required = false,
  }) : super(key: key);

  final String? labelText;
  final String? hintText;
  final String? errorText;
  final String? Function(String?)? validator;
  final Widget? prefixWidget;
  final Function(String)? onValueChanged;
  final Function()? onTap;
  final String? initialValue;
  final bool enabled;
  final bool? visible;
  final bool? readOnly;
  final bool? borderVisible;
  final bool? hideErrortext;
  final bool? obscureText;
  final TextInputType keyboardType;
  final bool expand;
  final bool required;
  @override
  State<CustomTextField> createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  final TextEditingController _textController = TextEditingController();
  bool _showError = false;
  String _errorText = '';

  String? lastInitialValue;

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

    return Visibility(
      visible: widget.visible ?? true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.labelText != null
              ? RichText(
                  text: TextSpan(text: widget.labelText, children: [
                  TextSpan(
                    text: widget.required ? ' *' : '',
                    style: CustomStyle.errorText,
                  )
                ]))
              : const SizedBox.shrink(),
          widget.labelText != null
              ? const SizedBox(height: 4)
              : const SizedBox.shrink(),
          Container(
            constraints: const BoxConstraints(minWidth: 200),
            child: TextFormField(
              // validator: widget.validator,
              // autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: widget.keyboardType,
              controller: _textController,
              cursorColor: _showError ? Colors.red : CustomColor.active,
              readOnly: widget.enabled
                  ? widget.readOnly == true
                      ? true
                      : false
                  : true,
              // expands: widget.expand,
              // maxLines: widget.expand == true ? null : 1,
              // minLines: widget.obscureText == true ? null : 1,
              obscureText: widget.obscureText ?? false,
              decoration: InputDecoration(
                  filled:
                      true, // Use filled property to change interior color when widget.enabled is false
                  fillColor:
                      widget.enabled ? Colors.white : CustomColor.lightest,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14.00),
                  constraints: const BoxConstraints.expand(
                      height: CustomSize.textFormFieldHeight),
                  hintText: widget.hintText,
                  hintStyle:
                      CustomStyle.regular14(color: CustomColor.slate_500),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: widget.borderVisible == false
                          ? Colors.transparent
                          : _showError
                              ? CustomColor.error
                              : CustomColor.slate_300,
                      width: 1,
                    ),
                    borderRadius: CustomStyle.customBorderRadiusSmall,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: widget.enabled
                        ? BorderSide(
                            color: widget.borderVisible == false
                                ? Colors.transparent
                                : _showError
                                    ? CustomColor.error
                                    : CustomColor.textPrimary,
                            width: 1,
                          )
                        : const BorderSide(
                            color: CustomColor.light,
                          ),
                    borderRadius: CustomStyle.customBorderRadiusSmall,
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: widget.borderVisible == false
                          ? Colors.transparent
                          : CustomColor.slate_200,
                      width: 1,
                    ),
                    borderRadius: CustomStyle.customBorderRadiusSmall,
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: CustomStyle.customBorderRadiusSmall,
                    borderSide: const BorderSide(color: CustomColor.error),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: CustomStyle.customBorderRadiusSmall,
                    borderSide: const BorderSide(color: CustomColor.error),
                  ),
                  prefixIcon: widget.prefixWidget != null
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: widget.prefixWidget,
                        )
                      : null,
                  hoverColor: Colors.transparent),
              style: CustomStyle.medium14(),
              onChanged: (value) {
                if (_showError == true) {
                  if (valid()) {
                    setState(
                      () {
                        _showError = false;
                      },
                    );
                  }
                }
                if (widget.onValueChanged != null) {
                  widget.onValueChanged!(value);
                }
              },
              onTap: widget.onTap,
            ),
          ),
          widget.hideErrortext == true
              ? SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    _showError ? _errorText : '',
                    style: CustomStyle.errorText,
                  ),
                ),
        ],
      ),
    );
  }

  bool valid() {
    if (widget.validator != null) {
      final String? validatorError = widget.validator!(_textController.text);
      if (validatorError != null) {
        setState(() {
          _showError = true;
          _errorText = validatorError;
        });
        return false;
      }
    }

    return true; // Return true if no validation is defined.
  }

  bool isValidEmail(String email) {
    // Regular expression for validating an email address
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  String? validatePassword(BuildContext context, String password) {
    // At least 6 characters
    if (password.length < 6) {
      return 'error_password_length'.tr(context);
    }

    // At least 1 uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return 'error_password_uppercase'.tr(context);
    }

    // At least 1 lowercase letter
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return 'error_password_lowercase'.tr(context);
    }

    // At least 1 number
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return 'error_password_number'.tr(context);
    }

    // At least 1 special character
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      return 'error_password_special'.tr(context);
    }

    // No whitespace characters
    if (RegExp(r'\s').hasMatch(password)) {
      return 'error_password_whitespace'.tr(context);
    }

    return null; // Password is valid
  }

  double getHeight() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    return renderBox.size.height;
  }
}
