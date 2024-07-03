import 'package:erp_frontend_v2/constants/sizes.dart';
import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/widgets/custom_search_bar.dart';
import 'package:erp_frontend_v2/widgets/custom_text_field.dart';
import 'package:erp_frontend_v2/widgets/custom_text_field_1.dart';
import 'package:erp_frontend_v2/widgets/filters/drop_down_filter/widgets/filtered_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

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
    this.validator,
    this.required = false,
  });
  final String? labelText;
  final Function(T) onValueChanged;
  final StateNotifierProvider<StateNotifier<AsyncValue<List<T>>>,
      AsyncValue<List<T>>>? provider;
  final String? hintText;
  final String? errorText;
  final T? initialValue;
  final bool enabled;
  final String? Function(String?)? validator;
  final bool required;

  @override
  ConsumerState<SearchDropDown<T>> createState() => SearchDropDownState<T>();
}

class SearchDropDownState<T> extends ConsumerState<SearchDropDown<T>> {
  final TextEditingController _textController = TextEditingController();
  List<T> dataList = [];
  List<T> filteredDataList = [];
  T? lastInitialValue;

  GlobalKey<FilteredListWidgetState> filteredListKey = GlobalKey();

  // Need for overlay
  bool isOverlayVisible = false;
  OverlayEntry? entry;
  final layerLink = LayerLink(); // I use to attach dropdown to textField

  bool _showError = false;
  String? _errorText = '';

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      _textController.text = (widget.initialValue as dynamic).name;
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncDataList = ref.watch(widget.provider!);

    if (widget.initialValue != null) {
      if (widget.initialValue != lastInitialValue) {
        lastInitialValue = widget.initialValue;
        _textController.text = (widget.initialValue as dynamic).name;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null)
          widget.required
              ? Row(
                  children: [
                    Text(
                      widget.labelText!,
                      style: CustomStyle.regular16(),
                    ),
                    Text(
                      ' *',
                      style: CustomStyle.regular16(color: CustomColor.error),
                    ),
                  ],
                )
              : Text('${widget.labelText!} (${'optional'.tr(context)})',
                  style: CustomStyle.regular16()),
        if (widget.labelText != null) const Gap(8.0),
        CompositedTransformTarget(
          link: layerLink,
          child: Stack(
            children: [
              TextFormField(
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
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  errorStyle: const TextStyle(
                    color: Colors.transparent,
                    fontSize: 0,
                  ),

                  isCollapsed: true,
                  prefixText: '    ',
                  alignLabelWithHint: true,
                  floatingLabelBehavior: FloatingLabelBehavior.never,

                  contentPadding: const EdgeInsets.fromLTRB(0, 12, 16, 12),
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
                      color: isOverlayVisible == true
                          ? CustomColor.textPrimary
                          : CustomColor.slate_300,
                    ),
                    borderRadius: CustomStyle.customBorderRadius,
                  ),
                  suffixIcon: const Icon(
                    Icons.expand_more_rounded,
                    color: CustomColor.slate_500,
                  ),

                  hintText: widget.hintText,
                  hintStyle:
                      CustomStyle.regular14(color: CustomColor.slate_500),

                  prefixIconConstraints:
                      BoxConstraints.tight(const Size(10, 60)),

                  errorMaxLines:
                      1, // ajustați numărul maxim de linii pentru mesajele de eroare
                ),
              ),
              Positioned.fill(
                child: InkWell(
                  highlightColor: Colors.transparent,
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
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(
            _errorText!,
            style: CustomStyle.semibold12(color: CustomColor.error),
          ),
        ),
      ],
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
                                hintText: 'Cauta',
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
                          _textController.text = (item as dynamic).name;
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

  // bool valid() {
  //   if (selectedItem == null) {
  //     setState(() {
  //       _showError = true;
  //     });
  //     return false;
  //   }
  //   return true;
}

  // //dispose
  // @override
  // void dispose() {
  //   if (entry != null) {
  //     entry?.remove();
  //     entry = null;
  //   }
  //   super.dispose();
  // }
// }
