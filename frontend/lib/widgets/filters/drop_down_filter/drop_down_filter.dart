import 'package:erp_frontend_v2/constants/sizes.dart';
import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/widgets/buttons/primary_button.dart';
import 'package:erp_frontend_v2/widgets/buttons/secondary_button.dart';
import 'package:erp_frontend_v2/widgets/custom_text_field.dart';
import 'package:erp_frontend_v2/widgets/filters/drop_down_filter/widgets/filtered_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DropDownFilter<T> extends ConsumerStatefulWidget {
  const DropDownFilter(
      {super.key,
      required this.labelText,
      required this.onValueChanged,
      this.provider,
      this.staticData,
      this.enableSearch = true});
  final String labelText;
  final Function(List<T>) onValueChanged;
  final ProviderListenable<AsyncValue<List<T>>>? provider;
  final List<T>? staticData;
  final bool? enableSearch;

  @override
  ConsumerState<DropDownFilter<T>> createState() => _DropDownFilterState<T>();
}

class _DropDownFilterState<T> extends ConsumerState<DropDownFilter<T>> {
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
  }

  Widget formatDisplayText() {
    String valueText = checkedItems.isEmpty
        ? 'all'.tr(context)
        : (checkedItems.first as dynamic).name;
    int additionalCount = checkedItems.length - 1;

    return Row(
      children: [
        Text('${widget.labelText}:  ',
            style: CustomStyle.regular14(color: CustomColor.greenGray)),
        Text(valueText, style: CustomStyle.semibold14()),
        if (additionalCount > 0)
          Text(', +$additionalCount', style: CustomStyle.semibold14()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Watching the provider
    final asyncDataList = widget.provider != null
        ? ref.watch(widget.provider!)
        : AsyncValue<List<T>>.data(const []);

    final displayText = formatDisplayText();
    return CompositedTransformTarget(
      link: layerLink,
      child: InkWell(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
          height: CustomSize.filterHeight,
          //color: CustomColor.white,
          decoration: CustomStyle.customContainerDecoration(
              border: true, borderRadius: CustomStyle.customBorderRadiusSmall),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              formatDisplayText(),
              const SizedBox(
                width: 8,
              ),
              const Icon(
                Icons.expand_more_rounded,
                color: CustomColor.medium,
                size: 20,
              ),
            ],
          ),
        ),
        onTap: () {
          if (widget.staticData != null) {
            dataList = widget.staticData!;
            filteredDataList = dataList;

            showOverlay();
          } else {
            asyncDataList.when(
              data: (List<T> data) {
                dataList = data;
                filteredDataList = dataList;
                showOverlay();
              },
              loading: () {
                // Handle loading state, e.g., show a loading indicator
              },
              error: (error, stack) {
                // Handle error state
              },
            );
          }
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

  Widget buildOverlay() {
    return TapRegion(
      onTapOutside: (event) {
        hideOverlay();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              decoration: CustomStyle.customContainerDecoration(),
              constraints: const BoxConstraints(
                maxHeight: 350.0, maxWidth: 350,
                //minHeight: 200,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Visibility(
                      visible: widget.enableSearch!,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: CustomTextField(
                              hintText: 'Cauta ${widget.labelText}',
                              onValueChanged: (value) {
                                List<T> newFilteredDataList =
                                    dataList.where((item) {
                                  final name = (item as dynamic).name as String;

                                  return name
                                      .toLowerCase()
                                      .contains(value.toLowerCase());
                                }).toList();
                                filteredListKey.currentState
                                    ?.updateList(newFilteredDataList);
                              },
                              hideErrortext: true,
                            ),
                          )
                        ],
                      ),
                    ),
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
                              //widget.onValueChanged(checkedItems);
                            });
                          },
                        ),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SecondaryButton(
                            text: 'clear_all'.tr(context),
                            onPressed: () {
                              setState(() {
                                checkedItems.clear();
                                filteredListKey.currentState
                                    ?.updateCheckedItems(checkedItems);
                                hideOverlay();
                              });
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 24,
                        ),
                        Expanded(
                          child: PrimaryButton(
                            text: 'Ok',
                            onPressed: () {
                              //widget.onValueChanged(checkedItems);
                              hideOverlay();
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )),
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
