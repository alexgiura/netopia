import 'package:erp_frontend_v2/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';

class CustomCalendar extends StatefulWidget {
  final List<DateTime?> initialValue;
  final Function(List<DateTime?>) onValueChanged;

  const CustomCalendar({
    Key? key,
    required this.initialValue,
    required this.onValueChanged,
  }) : super(key: key);

  @override
  _CustomCalendarState createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  late List<DateTime?> _selectedDates;

  @override
  void initState() {
    super.initState();
    _selectedDates = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    final config = CalendarDatePicker2Config(
        controlsHeight: 48,
        firstDayOfWeek: DateTime.monday,
        calendarType: CalendarDatePicker2Type.range,
        selectedDayHighlightColor: CustomColor.bgDark,
        selectedRangeHighlightColor: CustomColor.bgDark.withOpacity(0.04),
        weekdayLabelTextStyle: CustomStyle.bodyTextBold,
        controlsTextStyle: CustomStyle.bodyTextBold,
        dayTextStyle: CustomStyle.labelText);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CalendarDatePicker2(
          config: config,
          value: _selectedDates,
          onValueChanged: (dates) {
            setState(() {
              _selectedDates = dates;
            });
            widget.onValueChanged(dates);
          },
        ),
      ],
    );
  }

  String _getValueText(List<DateTime?> values) {
    if (values.isEmpty || values[0] == null) {
      return 'No date selected';
    } else {
      final startDate =
          values[0]!.toString().split(' ')[0]; // Format for display
      final endDate = values.length > 1 && values[1] != null
          ? values[1]!.toString().split(' ')[0]
          : 'No end date';
      return '$startDate to $endDate';
    }
  }
}
