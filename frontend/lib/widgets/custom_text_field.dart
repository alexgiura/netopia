import 'package:erp_frontend_v2/constants/sizes.dart';
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
    this.visible,
    this.onTap,
    this.readOnly,
    this.prefixIcon,
    this.borderVisible,
    this.hideErrortext,
  }) : super(key: key);

  final String? labelText;
  final String? hintText;
  final String? errorText;
  final IconData? prefixIcon;
  final Function(String)? onValueChanged;
  final Function()? onTap;
  final String? initialValue;
  final bool enabled;
  final bool? visible;
  final bool? readOnly;
  final bool? borderVisible;
  final bool? hideErrortext;

  @override
  State<CustomTextField> createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  final TextEditingController _textController = TextEditingController();
  bool _showError = false;

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
              ? Text(
                  widget.labelText!,
                  style: CustomStyle.labelText,
                )
              : const SizedBox.shrink(),
          widget.labelText != null
              ? const SizedBox(height: 4)
              : const SizedBox.shrink(),
          Container(
            constraints: const BoxConstraints(minWidth: 200),
            child: TextFormField(
              controller: _textController,
              cursorColor: _showError ? Colors.red : CustomColor.active,
              readOnly: widget.enabled
                  ? widget.readOnly == true
                      ? true
                      : false
                  : true,
              expands: true,
              maxLines: null,
              minLines: null,
              decoration: InputDecoration(
                  filled:
                      true, // Use filled property to change interior color when widget.enabled is false
                  fillColor:
                      widget.enabled ? Colors.white : CustomColor.lightest,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14.00),
                  constraints: const BoxConstraints.expand(
                      height: CustomSize.textFormFieldHeight),
                  hintText: widget.hintText,
                  hintStyle: CustomStyle.hintText,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: widget.borderVisible == false
                          ? Colors.transparent
                          : _showError
                              ? Colors.red
                              : CustomColor.light,
                      width: 0.5,
                    ),
                    borderRadius: CustomStyle.customBorderRadius,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: widget.enabled
                        ? BorderSide(
                            color: widget.borderVisible == false
                                ? Colors.transparent
                                : _showError
                                    ? Colors.red
                                    : CustomColor.active,
                            width: 1,
                          )
                        : const BorderSide(
                            color: CustomColor.light,
                          ),
                    borderRadius: CustomStyle.customBorderRadius,
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: widget.borderVisible == false
                          ? Colors.transparent
                          : CustomColor.light,
                      width: 0.5,
                    ),
                    borderRadius: CustomStyle.customBorderRadius,
                  ),
                  prefixIcon: widget.prefixIcon != null
                      ? Icon(
                          widget.prefixIcon,
                          color: CustomColor.medium,
                        )
                      : null,
                  hoverColor: Colors.transparent),
              style: CustomStyle.bodyText,
              onChanged: (value) {
                if (widget.errorText != null) {
                  if (valid() && _showError == true) {
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
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    _showError ? widget.errorText! : '',
                    style: CustomStyle.errorText,
                  ),
                ),
          // widget.errorText != null
          //     ? const SizedBox(height: 2)
          //     : SizedBox.shrink(),
          // widget.errorText != null
          //     ? Text(
          //         _showError ? widget.errorText! : '',
          //         style: CustomStyle.errorText,
          //       )
          //     : SizedBox.shrink(),
        ],
      ),
    );
  }

  bool valid() {
    if (_textController.text == '') {
      setState(() {
        _showError = true;
      });
      return false;
    }
    return true; // Return true if no validation is defined.
  }

  double getHeight() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    return renderBox.size.height;
  }
}
