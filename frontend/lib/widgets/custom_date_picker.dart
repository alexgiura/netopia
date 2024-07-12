import 'package:erp_frontend_v2/constants/sizes.dart';
import 'package:erp_frontend_v2/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerWidget extends StatefulWidget {
  const DatePickerWidget(
      {Key? key,
      required this.labelText,
      required this.onDateChanged,
      this.hintText,
      this.initialValue,
      this.enabled = true,
      this.errorText})
      : super(key: key);

  final DateTime? initialValue;
  final String labelText;
  final String? hintText;
  final void Function(DateTime date) onDateChanged;
  final bool enabled;
  final String? errorText;

  @override
  State<DatePickerWidget> createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  DateTime? selectedDate;

  final bool _showError = false;

  DateTime? lastInitialValue;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      lastInitialValue = widget.initialValue;
      selectedDate = widget.initialValue!;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.initialValue != null) {
      if (widget.initialValue != lastInitialValue) {
        lastInitialValue = widget.initialValue!;
        selectedDate = widget.initialValue!;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.labelText,
          style: CustomStyle.labelText,
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: widget.enabled
              ? () {
                  showDatePicker(
                    context: context,
                    initialDate: widget.initialValue ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  ).then((pickedDate) {
                    if (pickedDate != null) {
                      setState(() {
                        selectedDate = pickedDate;
                        widget.onDateChanged(pickedDate);
                      });
                    }
                  });
                }
              : null, // Set onTap to null when disabled
          child: Container(
            height: CustomSize.textFormFieldHeight,
            padding: const EdgeInsets.only(left: 8),
            decoration: BoxDecoration(
              border: Border.all(width: 0.5, color: CustomColor.light),
              borderRadius: CustomStyle.customBorderRadius,
              color: widget.enabled ? Colors.white : CustomColor.lightest,
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                      selectedDate != null
                          ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                          : widget.hintText != null
                              ? widget.hintText!
                              : '',
                      overflow: TextOverflow.ellipsis,
                      style: selectedDate != null
                          ? CustomStyle.bodyText
                          : CustomStyle.hintText),
                ),
                // Container(color: Colors.transparent, child: const Spacer()),
                widget.hintText != null && selectedDate != null
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            selectedDate = null;
                          });
                        },
                        icon: const Icon(
                          Icons.clear,
                          size: 18,
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
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
}
