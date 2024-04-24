import 'package:erp_frontend_v2/constants/sizes.dart';
import 'package:flutter/material.dart';

import '../constants/style.dart';

class CustomDropdown<T> extends StatefulWidget {
  const CustomDropdown({
    super.key,
    this.labelText,
    required this.onValueChanged,
    required this.dataList,
    this.enabled,
    this.hintText,
    this.errorText,
    this.initialValue,
  });
  final String? labelText;
  final Function(T) onValueChanged;
  final List<T> dataList;

  final bool? enabled;
  final String? hintText;
  final String? errorText;
  final T? initialValue;

  @override
  State<CustomDropdown<T>> createState() => CustomDropdownState<T>();
}

class CustomDropdownState<T> extends State<CustomDropdown<T>> {
  // State Variables
  bool _showError = false;
  bool isOverlayVisible = false;
  final _textController = TextEditingController();
  OverlayEntry? entry;
  final layerLink = LayerLink(); // I use to attach dropdown to textField

  T? lastInitialValue;

// initState
  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      lastInitialValue = widget.initialValue as T;
      _textController.text = (widget.initialValue as dynamic).name;
    }
  }

// custom Widget
  Widget customTextFormField() {
    return CompositedTransformTarget(
      link: layerLink,
      child: Container(
        height: CustomSize.textFormFieldHeight,
        child: TextFormField(
          showCursor: false,
          mouseCursor: MaterialStateMouseCursor.clickable,
          readOnly: true,
          controller: _textController,
          cursorColor: CustomColor.active,
          decoration: InputDecoration(
            filled:
                true, // Use filled property to change interior color when widget.enabled is false
            fillColor: (widget.enabled != null && widget.enabled == false)
                ? CustomColor.lightest
                : Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            hintText: widget.hintText,
            hintStyle: CustomStyle.hintText,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: _showError ? Colors.red : CustomColor.light,
                width: 0.5,
              ),
              borderRadius: CustomStyle.customBorderRadius,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: _showError ? Colors.red : CustomColor.active,
                width: 1.0,
              ),
              borderRadius: CustomStyle.customBorderRadius,
            ),
            suffixIcon: Icon(
              Icons.arrow_drop_down,
              color: isOverlayVisible ? CustomColor.active : CustomColor.medium,
            ),
          ),
          style: CustomStyle.bodyText,
          onTap: () {
            widget.enabled == false ? {} : showOverlay();
          },
        ),
      ),
    );
  }

  Widget buildOverlay() => Material(
        clipBehavior: Clip.antiAlias,
        borderRadius: CustomStyle.customBorderRadius,
        color: CustomColor.white,
        elevation: 4,
        child: TapRegion(
          onTapOutside: (event) {
            setState(() {
              hideOverlay();
            });
          },
          child: Container(
            constraints: BoxConstraints(
              maxHeight: 300.0, // Maximum height for the overlay
            ),
            child: ListView(
              shrinkWrap: true,
              children: widget.dataList.isEmpty
                  ? [
                      const ListTile(
                        title:
                            Text("No data"), // Customize the message as needed
                      ),
                    ]
                  : widget.dataList.map((T option) {
                      final dynamic name = ((option as dynamic).name);
                      return ListTile(
                        hoverColor: CustomColor.lightest,
                        title: Text(name),
                        onTap: () {
                          setState(() {
                            _textController.text = name;
                            hideOverlay();
                            widget.onValueChanged(option);
                            _showError = false;
                          });
                        },
                      );
                    }).toList(),
            ),
          ),
        ),
      );

  // Build Method
  @override
  Widget build(BuildContext context) {
    if (widget.initialValue != null) {
      if (widget.initialValue != lastInitialValue) {
        lastInitialValue = widget.initialValue!;
        _textController.text = (widget.initialValue as dynamic).name;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.labelText != null
            ? Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(widget.labelText!, style: CustomStyle.labelText),
              )
            : SizedBox.shrink(),
        customTextFormField(),
        _showError ? const SizedBox(height: 2) : Container(),
        _showError
            ? Text(
                _showError ? widget.errorText! : '',
                style: CustomStyle.errorText,
              )
            : Container(),
      ],
    );
  }

  // Helper Methods
  void showOverlay() {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    entry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: layerLink,
          showWhenUnlinked: false,
          offset: const Offset(
            0,
            CustomSize.textFormFieldHeight + 4,
          ),
          child: buildOverlay(),
        ),
      ),
    );
    overlay.insert(entry!);
    setState(() {
      isOverlayVisible = true;
    });
  }

  void hideOverlay() {
    entry?.remove();
    entry = null;
    setState(() {
      isOverlayVisible = false;
    });
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

//dispose
  @override
  void dispose() {
    _textController.dispose();

    // Check if the overlay entry exists and remove it
    if (entry != null) {
      entry?.remove();
      entry = null;
    }
    super.dispose();
  }
}
