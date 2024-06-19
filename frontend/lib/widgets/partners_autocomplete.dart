import 'package:flutter/material.dart';

import '../constants/style.dart';
import '../models/partner/partner_model.dart';
import 'custom_text_field.dart';

class PartnerSearchWidget extends StatefulWidget {
  const PartnerSearchWidget(
      {super.key,
      required this.labelText,
      required this.hintText,
      this.readOnly,
      required this.onValueChanged,
      required this.partnersList,
      this.initialValue});

  final String labelText;
  final String? hintText;
  final bool? readOnly;
  final Function(String) onValueChanged;
  final List<Partner> partnersList;
  final String? initialValue;

  @override
  State<PartnerSearchWidget> createState() => PartnerSearchWidgetState();
}

class PartnerSearchWidgetState extends State<PartnerSearchWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    if (widget.initialValue == "" &&
        widget.initialValue != _textEditingController.text) {
      _textEditingController.text = widget.initialValue!;
    }
    if (widget.readOnly == true || widget.readOnly == null) {
      return _buildAutocomplete(context);
    } else {
      return _buildReadOnlyField();
    }
  }

  Widget _buildAutocomplete(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.labelText, style: CustomStyle.labelText),
        const SizedBox(height: 4),
        LayoutBuilder(builder: (context, constraints) {
          return RawAutocomplete<Partner>(
            focusNode: _focusNode,
            textEditingController: _textEditingController,
            optionsBuilder: (TextEditingValue textValue) {
              final partnersList = widget.partnersList;
              return partnersList
                  .where((Partner suggestion) => suggestion.name
                      .toLowerCase()
                      .contains(textValue.text.toLowerCase()))
                  .toList();
            },
            displayStringForOption: (Partner option) => option.name,
            onSelected: (Partner selectedValue) {
              setState(() {
                widget.onValueChanged(selectedValue.name);
              });
            },
            optionsViewBuilder: (
              BuildContext context,
              AutocompleteOnSelected<Partner> onSelected,
              Iterable<Partner> options,
            ) {
              return Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    constraints: const BoxConstraints(
                      maxHeight: 300.0,
                    ),
                    decoration: CustomStyle.customContainerDecoration(),
                    width: constraints.biggest.width,
                    child: Material(
                      borderRadius: CustomStyle.customBorderRadius,
                      color: CustomColor.white,
                      child: ListView(
                        shrinkWrap: true,
                        children: options.map((Partner option) {
                          return ListTile(
                            hoverColor: CustomColor.lightest,
                            title: Text(option.name),
                            onTap: () {
                              onSelected(option);
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              );
            },
            fieldViewBuilder:
                (context, textEditingController, focusNode, onFieldSubmitted) {
              return Container(
                height: 40,
                child: TextFormField(
                  cursorColor: CustomColor.active,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    hintText: widget.hintText,
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: CustomColor.light,
                        width: 1,
                      ),
                      borderRadius: CustomStyle.customBorderRadius,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: CustomColor.active,
                        width: 1.5,
                      ),
                      borderRadius: CustomStyle.customBorderRadius,
                    ),
                    suffixIcon: textEditingController.text.isNotEmpty
                        ? InkWell(
                            onTap: () {
                              setState(() {
                                _textEditingController.clear();
                              });
                            },
                            child: const Icon(
                              Icons.clear,
                              color: CustomColor.dark,
                              size: 18,
                            ),
                          )
                        : null,
                  ),
                  controller: _textEditingController,
                  focusNode: _focusNode,
                  style: CustomStyle.bodyText,
                  onChanged: (String value) {
                    setState(() {
                      widget.onValueChanged(value);
                    });
                  },
                  onFieldSubmitted: (String value) {
                    onFieldSubmitted();
                  },
                ),
              );
            },
          );
        }),
      ],
    );
  }

  Widget _buildReadOnlyField() {
    return CustomTextField(
        labelText: widget.labelText,
        hintText: widget.hintText,
        initialValue: widget.initialValue!,
        enabled: false,
        onValueChanged: (String value) {});
  }
}
