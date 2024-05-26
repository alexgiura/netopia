import 'package:erp_frontend_v2/constants/sizes.dart';
import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/widgets/custom_search_bar.dart';
import 'package:erp_frontend_v2/widgets/custom_text_field.dart';
import 'package:erp_frontend_v2/widgets/filters/drop_down_filter/widgets/filtered_list_widget.dart';
import 'package:erp_frontend_v2/widgets/phone_field/widgets/filtered_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_field/countries.dart';

class CustomPhoneField<T> extends ConsumerStatefulWidget {
  const CustomPhoneField({
    super.key,
    this.labelText,
    this.enabled = true,
    required this.onValueChanged,
    this.readOnly,
    this.hintText,
    this.errorText,
    this.initialValue,
  });
  final String? labelText;
  final Function(String) onValueChanged;
  final String? hintText;
  final String? errorText;
  final String? initialValue;
  final bool enabled;
  final bool? readOnly;

  @override
  ConsumerState<CustomPhoneField<T>> createState() =>
      CustomPhoneFieldState<T>();
}

class CustomPhoneFieldState<T> extends ConsumerState<CustomPhoneField<T>> {
  List<Country> countryList = countries;
  List<Country> filteredCountryList = countries;
  Country? selectedCountry;
  String _phone = '';

  GlobalKey<CountryFilteredListWidgetState> filteredListKey = GlobalKey();

  // Need for overlay
  bool isOverlayVisible = false;
  OverlayEntry? entry;
  final layerLink = LayerLink(); // I use to attach dropdown to textField

  bool _showError = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      selectedCountry = _getCountryFromInitialValue(widget.initialValue!);
      _phone = _removePrefix(widget.initialValue!, selectedCountry!.dialCode);
    } else {
      selectedCountry = countries.firstWhere((country) => country.code == 'RO');
    }
  }

  Country _getCountryFromInitialValue(String initialValue) {
    // Remove the '+' if it exists
    if (initialValue.startsWith('+')) {
      initialValue = initialValue.substring(1);
    }

    // Extract the country code or prefix from the initial value
    for (var country in countries) {
      if (initialValue.startsWith(country.dialCode)) {
        return country;
      }
    }
    // Default to 'RO' if no match is found
    return countries.firstWhere((country) => country.code == 'RO');
  }

  String _removePrefix(String initialValue, String dialCode) {
    if (initialValue.startsWith('+')) {
      initialValue = initialValue.substring(1);
    }
    return initialValue.replaceFirst(dialCode, '');
  }

  @override
  Widget build(BuildContext context) {
    
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
            child: CustomTextField(
              // labelText: "Telefon",

              hintText: "Numar telefon",
              initialValue: _phone,
              onValueChanged: (String value) {
                _phone = value;
                widget.onValueChanged("+${selectedCountry!.dialCode}$value");
              },
              prefixWidget: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'packages/intl_phone_field/assets/flags/${selectedCountry!.code.toLowerCase()}.png',
                          width: 24,
                          height: 16,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 8),
                        Text("+${selectedCountry!.dialCode}"),
                      ],
                    ),
                    onTap: () {
                      if (widget.enabled) {
                        showOverlay();
                      }
                    },
                  )
                ],
              ),
            ),
          ),
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
            decoration: CustomStyle.customContainerDecoration,
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
                  countryList.length > 6
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: CustomSearchBar(
                                hintText: 'Cauta',
                                onValueChanged: (value) {
                                  List<Country> newFilteredDataList =
                                      countryList.where((item) {
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
                  
                  Flexible(
                    child: CountryFilteredListWidget<T>(
                      key: filteredListKey,
                      initialDataList: filteredCountryList,
                      checkedItems: null,
                      onItemChanged: (bool newValue, Country country) {
                        setState(() {
                          selectedCountry = country;
                          hideOverlay();

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
  // }

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
