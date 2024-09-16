import 'package:erp_frontend_v2/constants/sizes.dart';
import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/widgets/buttons/primary_button.dart';
import 'package:erp_frontend_v2/widgets/buttons/secondary_button.dart';
import 'package:erp_frontend_v2/widgets/custom_text_field.dart';
import 'package:erp_frontend_v2/widgets/filters/drop_down_filter/widgets/filtered_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';

class DropDownFilter<T> extends StatefulWidget {
  const DropDownFilter({
    super.key,
    required this.labelText,
    required this.onValueChanged,
    required this.staticData,
    this.enableSearch = true,
  });

  final String labelText;
  final Function(List<T>) onValueChanged;
  final List<T> staticData;
  final bool? enableSearch;

  @override
  State<DropDownFilter<T>> createState() => _DropDownFilterState<T>();
}

class _DropDownFilterState<T> extends State<DropDownFilter<T>> {
  List<T> dataList = [];
  List<T> filteredDataList = [];

  List<T> checkedItems = [];

  GlobalKey<FilteredListWidgetState> filteredListKey = GlobalKey();

  // Need for overlay
  bool isOverlayVisible = false;
  OverlayEntry? entry;
  final layerLink = LayerLink(); // I use to attach dropdown to textField

  @override
  void initState() {
    super.initState();
    dataList = widget.staticData;
    filteredDataList = dataList;
  }

  Widget formatDisplayText() {
    String valueText =
        checkedItems.isEmpty ? 'all' : (checkedItems.first as dynamic).name;
    int additionalCount = checkedItems.length - 1;

    return Row(
      children: [
        Text('${widget.labelText}:  ',
            style: TextStyle(color: Colors.grey, fontSize: 14)),
        Text(valueText,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        if (additionalCount > 0)
          Text(', +$additionalCount',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayText = formatDisplayText();
    return CompositedTransformTarget(
      link: layerLink,
      child: InkWell(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
          height: 48,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              displayText,
              const SizedBox(
                width: 8,
              ),
              const Icon(
                Icons.expand_more_rounded,
                color: Colors.grey,
                size: 20,
              ),
            ],
          ),
        ),
        onTap: () {
          dataList = widget.staticData;
          filteredDataList = dataList;
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
          offset: const Offset(0, 52),
          child: buildOverlay(),
        ),
      ),
    );
    overlay.insert(entry!);
    setState(() {
      isOverlayVisible = true;
    });
  }

  Widget buildOverlay() {
    return GestureDetector(
      onTap: () => hideOverlay(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                )
              ],
            ),
            constraints: const BoxConstraints(maxHeight: 350.0, maxWidth: 350),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Visibility(
                  //   visible: widget.enableSearch!,
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //         child: TextField(
                  //           decoration: InputDecoration(
                  //             hintText: 'Search ${widget.labelText}',
                  //             border: OutlineInputBorder(
                  //               borderRadius: BorderRadius.circular(8),
                  //             ),
                  //           ),
                  //           onChanged: (value) {
                  //             setState(() {
                  //               filteredDataList = dataList.where((item) {
                  //                 final name = (item as dynamic).name as String;
                  //                 return name
                  //                     .toLowerCase()
                  //                     .contains(value.toLowerCase());
                  //               }).toList();
                  //             });
                  //           },
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: FilteredListWidget<T>(
                        key: filteredListKey,
                        initialDataList: filteredDataList,
                        checkedItems: checkedItems,
                        onItemChanged: (bool newValue, T item) {
                          setState(() {
                            if (newValue) {
                              checkedItems.add(item);
                            } else {
                              checkedItems.remove(item);
                            }
                          });
                        },
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              checkedItems.clear();
                              filteredListKey.currentState
                                  ?.updateCheckedItems(checkedItems);
                              hideOverlay();
                            });
                          },
                          child: Text('Clear All'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            hideOverlay();
                          },
                          child: Text('Ok'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void hideOverlay() {
    entry?.remove();
    entry = null;
    setState(() {
      isOverlayVisible = false;
      widget.onValueChanged(checkedItems);
    });
  }

  @override
  void dispose() {
    entry?.remove();
    super.dispose();
  }
}
