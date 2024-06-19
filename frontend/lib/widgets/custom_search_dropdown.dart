import 'package:erp_frontend_v2/constants/sizes.dart';
import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/widgets/custom_search_bar.dart';
import 'package:erp_frontend_v2/widgets/filters/drop_down_filter/widgets/filtered_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchDropDown<T> extends ConsumerStatefulWidget {
  const SearchDropDown({
    super.key,
    this.labelText,
    this.enabled = true,
    required this.onValueChanged,
    this.provider,
    this.hintText,
    this.errorText,
    this.initialValue,
  });
  final String? labelText;
  final Function(T) onValueChanged;
  final ProviderListenable<AsyncValue<List<T>>>? provider;
  final String? hintText;
  final String? errorText;
  final T? initialValue;
  final bool enabled;

  @override
  ConsumerState<SearchDropDown<T>> createState() => SearchDropDownState<T>();
}

class SearchDropDownState<T> extends ConsumerState<SearchDropDown<T>> {
  List<T> dataList = [];
  List<T> filteredDataList = [];

  // List<T> checkedItems = [];
  T? selectedItem;

  GlobalKey<FilteredListWidgetState> filteredListKey = GlobalKey();

  // Need for overlay
  bool isOverlayVisible = false;
  OverlayEntry? entry;
  final layerLink = LayerLink(); // I use to attach dropdown to textField

  bool _showError = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      selectedItem = widget.initialValue;
    }
    //ref.invalidate(widget.provider);
  }

  @override
  Widget build(BuildContext context) {
    final asyncDataList = ref.watch(widget.provider!);

    return Container(
      color: CustomColor.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.labelText != null
              ? Text(widget.labelText!, style: CustomStyle.labelText)
              : const SizedBox.shrink(),
          widget.labelText != null
              ? const SizedBox(height: 4)
              : const SizedBox.shrink(),
          CompositedTransformTarget(
            link: layerLink,
            child: InkWell(
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
                height: CustomSize.textFormFieldHeight,
                decoration: widget.enabled
                    ? _showError == false
                        ? CustomStyle.customContainerDecorationNoShadow
                        : CustomStyle.customErrorContainerDecoration
                    : CustomStyle.customInactiveContainerDecoration,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(selectedItem != null
                        ? (selectedItem as dynamic).name
                        : ''),
                    const Spacer(),
                    const Icon(
                      Icons.expand_more_rounded,
                      color: CustomColor.medium,
                      size: 20,
                    ),
                  ],
                ),
              ),
              onTap: () {
                asyncDataList.when(
                  data: (List<T> data) {
                    dataList = data;
                    filteredDataList = dataList;
                    if (widget.enabled != false) {
                      showOverlay();
                    }
                  },
                  loading: () {},
                  error: (error, stack) {},
                );
              },
            ),
          ),
          // Error message
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              _showError ? widget.errorText! : '',
              style: CustomStyle.errorText,
            ),
          )
        ],
      ),
    );
  }

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

  Widget buildOverlay() => Material(
      clipBehavior: Clip.antiAlias,
      borderRadius: CustomStyle.customBorderRadius,
      color: CustomColor.white,
      elevation: 4,
      child: TapRegion(
        onTapOutside: (event) {
          hideOverlay();
        },
        child: Container(
            decoration: CustomStyle.customContainerDecoration(),
            constraints: const BoxConstraints(
              maxHeight: 350.0,
              //maxWidth: 350,
              //minHeight: 200,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  dataList.length > 6
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: CustomSearchBar(
                                hintText: 'Cauta Partener',
                                onValueChanged: (value) {
                                  List<T> newFilteredDataList =
                                      dataList.where((item) {
                                    final name =
                                        (item as dynamic).name as String;
                                    return name
                                        .toLowerCase()
                                        .contains(value.toLowerCase());
                                  }).toList();
                                  filteredListKey.currentState
                                      ?.updateList(newFilteredDataList);
                                },
                                //visibleBorder: false,
                              ))
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                  // const SizedBox(
                  //   height: 8,
                  // ),
                  Flexible(
                    child: FilteredListWidget<T>(
                      key: filteredListKey,
                      initialDataList: filteredDataList,
                      checkedItems: null,
                      onItemChanged: (bool newValue, T item) {
                        setState(() {
                          selectedItem = item;
                          hideOverlay();
                          widget.onValueChanged(item);
                          _showError = false;
                        });
                      },
                    ),
                  ),
                ],
              ),
            )),
      ));

  void hideOverlay() {
    entry?.remove();
    entry = null;
    setState(() {
      isOverlayVisible = false;
    });
  }

  void refreshOverlay() {
    entry?.remove();
    showOverlay();
  }

  bool valid() {
    if (selectedItem == null) {
      setState(() {
        _showError = true;
      });
      return false;
    }
    return true;
  }

  //dispose
  @override
  void dispose() {
    if (entry != null) {
      entry?.remove();
      entry = null;
    }
    super.dispose();
  }
}
