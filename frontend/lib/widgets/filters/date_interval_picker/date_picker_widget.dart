import 'package:erp_frontend_v2/constants/sizes.dart';
import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/widgets/buttons/primary_button.dart';
import 'package:erp_frontend_v2/widgets/buttons/secondary_button.dart';
import 'package:erp_frontend_v2/widgets/custom_calendar.dart';
import 'package:erp_frontend_v2/widgets/filters/drop_down_filter/widgets/filtered_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class DateIntervalPickerFilter<T> extends ConsumerStatefulWidget {
  const DateIntervalPickerFilter(
      {super.key,
      required this.labelText,
      required this.onValueChanged,
      this.initialStartDate,
      this.initialEndDate});
  final String labelText;
  final Function(DateTime startDate, DateTime endDate) onValueChanged;
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;

  @override
  ConsumerState<DateIntervalPickerFilter<T>> createState() =>
      _DateIntervalPickerFilterState<T>();
}

class _DateIntervalPickerFilterState<T>
    extends ConsumerState<DateIntervalPickerFilter<T>> {
  GlobalKey<FilteredListWidgetState> filteredListKey = GlobalKey();

  List<DateTime?> _rangeDatePickerValue = [
    DateTime.now(),
    DateTime.now(),
    //DateTime.now().add(const Duration(days: 5)),
  ];

  // Need for overlay
  bool isOverlayVisible = false;
  OverlayEntry? entry;
  final layerLink = LayerLink(); // I use to attach dropdown to textField

  @override
  void initState() {
    super.initState();
    if (widget.initialStartDate != null && widget.initialEndDate != null) {
      _rangeDatePickerValue[0] = widget.initialStartDate;
      _rangeDatePickerValue[1] = widget.initialEndDate;
    }
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    // if (widget.initialStartDate != null && widget.initialEndDate != null) {
    //   _rangeDatePickerValue[0] = widget.initialStartDate;
    //   _rangeDatePickerValue[1] = widget.initialEndDate;
    // }
  }

  Widget formatDisplayText() {
    final today = DateTime.now();

    final startOfThisWeek = today.subtract(Duration(days: today.weekday - 1));
    final endOfThisWeek = startOfThisWeek.add(const Duration(days: 6));
    final startOfThisMonth = DateTime(today.year, today.month);
    final endOfThisMonth = DateTime(today.year, today.month + 1, 0);
    final startOfThisYear = DateTime(today.year);
    final endOfThisYear = DateTime(today.year, 12, 31);

    String dateText = 'All'; // Default text if no date range is selected

    if (_rangeDatePickerValue.isNotEmpty && _rangeDatePickerValue[0] != null) {
      if (_rangeDatePickerValue.length == 1 ||
          (_rangeDatePickerValue.length == 2 &&
              _rangeDatePickerValue[0] == _rangeDatePickerValue[1])) {
        // Display as a single day format when only one date is selected or both dates are the same
        dateText = DateUtils.isSameDay(_rangeDatePickerValue[0]!, today)
            ? 'Astăzi'
            : _formatDate(_rangeDatePickerValue[0]);
      } else if (_rangeDatePickerValue.length == 2) {
        // Display date range
        if (DateUtils.isSameDay(_rangeDatePickerValue[0]!, today) &&
            DateUtils.isSameDay(_rangeDatePickerValue[1]!, today)) {
          dateText = 'Astăzi';
        } else if (DateUtils.isSameDay(
                _rangeDatePickerValue[0]!, startOfThisWeek) &&
            DateUtils.isSameDay(_rangeDatePickerValue[1]!, endOfThisWeek)) {
          dateText = 'Săptămâna curentă';
        } else if (DateUtils.isSameDay(
                _rangeDatePickerValue[0]!, startOfThisMonth) &&
            DateUtils.isSameDay(_rangeDatePickerValue[1]!, endOfThisMonth)) {
          dateText = 'Luna curentă';
        } else if (DateUtils.isSameDay(
                _rangeDatePickerValue[0]!, startOfThisYear) &&
            DateUtils.isSameDay(_rangeDatePickerValue[1]!, endOfThisYear)) {
          dateText = 'Anul curent';
        } else {
          final startDate = _formatDate(_rangeDatePickerValue[0]);
          final endDate = _formatDate(_rangeDatePickerValue[1]);
          dateText = '$startDate - $endDate';
        }
      }
    }

    return Row(
      children: [
        Text('${'date'.tr(context)}:  ',
            style: CustomStyle.regular14(color: CustomColor.greenGray)),
        Text(dateText, style: CustomStyle.semibold14()),
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('d MMM').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: layerLink,
      child: InkWell(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
          height: CustomSize.filterHeight,
          decoration: CustomStyle.customContainerDecoration(
            border: true,
            borderRadius: CustomStyle.customBorderRadiusSmall,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              formatDisplayText(),
              const SizedBox(width: 8),
              const Icon(
                Icons.expand_more_rounded,
                color: CustomColor.medium,
                size: 20,
              ),
            ],
          ),
        ),
        onTap: () {
          showOverlay();
        },
      ),
    );
  }

  void showOverlay() {
    final overlay = Overlay.of(context);

    entry = OverlayEntry(
      builder: (context) => Positioned(
        child: CompositedTransformFollower(
          link: layerLink,
          showWhenUnlinked: false,
          offset: const Offset(
            0,
            CustomSize.filterHeight + 4,
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

  Widget _buildPredefinedDateOption(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Text(label, style: CustomStyle.bodyText),
      ),
    );
  }

  void _updateDateRange(List<DateTime> newRange) {
    setState(() {
      _rangeDatePickerValue = newRange;
      refreshOverlay(); // Refresh the overlay to update the CustomCalendar
    });
  }

  void _applyDateChange() {
    setState(() {
      if (_rangeDatePickerValue.length == 2) {
        widget.onValueChanged(
            _rangeDatePickerValue[0]!, _rangeDatePickerValue[1]!);
      } else if (_rangeDatePickerValue.length == 1) {
        widget.onValueChanged(
            _rangeDatePickerValue[0]!, _rangeDatePickerValue[0]!);
      }
    });
  }

  Widget buildOverlay() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TapRegion(
          onTapOutside: (event) {
            hideOverlay();
          },
          child: Container(
            decoration: CustomStyle.customContainerDecoration(
              borderRadius: CustomStyle.customBorderRadiusSmall,
            ),
            constraints: const BoxConstraints(
              //maxHeight: 400,
              maxWidth: 480,
              //minHeight: 200,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Predefined date options
                        _buildPredefinedDateOption('Astăzi', () {
                          final today = DateTime.now();
                          _updateDateRange([today, today]);
                          hideOverlay();
                        }),
                        _buildPredefinedDateOption('Săptămâna curentă', () {
                          final today = DateTime.now();
                          final startOfWeek =
                              today.subtract(Duration(days: today.weekday - 1));
                          final endOfWeek =
                              startOfWeek.add(const Duration(days: 6));
                          _updateDateRange([startOfWeek, endOfWeek]);
                          hideOverlay();
                        }),
                        _buildPredefinedDateOption('Luna curentă', () {
                          final today = DateTime.now();
                          final startOfMonth =
                              DateTime(today.year, today.month);
                          final endOfMonth =
                              DateTime(today.year, today.month + 1, 0);
                          _updateDateRange([startOfMonth, endOfMonth]);
                          hideOverlay();
                        }),
                        _buildPredefinedDateOption('Anul curent', () {
                          final today = DateTime.now();
                          final startOfYear = DateTime(today.year);
                          final endOfYear = DateTime(today.year + 1, 1, 0);
                          _updateDateRange([startOfYear, endOfYear]);
                          hideOverlay();
                        }),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CustomCalendar(
                        initialValue: _rangeDatePickerValue,
                        onValueChanged: (newDates) {
                          _rangeDatePickerValue = newDates;
                          // setState(() {
                          //   _rangeDatePickerValue = newDates;
                          //   if (newDates.length == 2) {
                          //     widget.onValueChanged(newDates[0]!, newDates[1]!);
                          //   }
                          // });
                        },
                      ),
                      const Divider(
                        height: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Spacer(),
                            Expanded(
                              child: SecondaryButton(
                                text: 'cancel'.tr(context),
                                onPressed: () {
                                  setState(() {});
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: PrimaryButton(
                                text: 'apply'.tr(context),
                                onPressed: () {
                                  hideOverlay();
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void hideOverlay() {
    entry?.remove();
    entry = null;
    setState(() {
      isOverlayVisible = false;
      _applyDateChange();
    });
  }

  void refreshOverlay() {
    entry?.remove(); // Remove the existing overlay entry
    showOverlay(); // Create and show the new overlay
  }

  //dispose
  @override
  void dispose() {
    // Check if the overlay entry exists and remove it
    if (entry != null) {
      entry?.remove();
      entry = null;
    }
    super.dispose();
  }
}
