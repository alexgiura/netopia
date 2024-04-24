import 'package:flutter/material.dart';

import '../constants/style.dart';
import '../models/partner/partner_model.dart';
import '../widgets/custom_text_field.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _showError = false;
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return
        // AlertDialog(
        //   content: Container(
        //     height: 40,
        //     child: TextFormField(
        //       cursorColor: CustomColor.active,
        //       decoration: InputDecoration(
        //         contentPadding: EdgeInsets.symmetric(horizontal: 8),
        //         enabledBorder: OutlineInputBorder(
        //           borderSide: const BorderSide(
        //             color: CustomColor.light,
        //             width: 1,
        //           ),
        //           borderRadius: CustomStyle.customBorderRadius,
        //         ),
        //         focusedBorder: OutlineInputBorder(
        //           borderSide: const BorderSide(
        //             color: CustomColor.active,
        //             width: 1.5,
        //           ),
        //           borderRadius: CustomStyle.customBorderRadius,
        //         ),
        //         suffixIcon: textEditingController.text.isNotEmpty
        //             ? InkWell(
        //                 onTap: () {
        //                   setState(() {
        //                     textEditingController.clear();
        //                   });
        //                 },
        //                 child: const Icon(
        //                   Icons.clear,
        //                   color: CustomColor.dark,
        //                   size: 18,
        //                 ),
        //               )
        //             : null,
        //       ),
        //       controller: textEditingController,
        //       // focusNode: focusNode,
        //       style: CustomStyle.bodyText,
        //       onChanged: (String value) {
        //         // setState(() {
        //         //   widget.onValueChanged(value);
        //         // });
        //       },
        //       onFieldSubmitted: (String value) {},
        //     ),
        //   ),
        // );

        AlertDialog(
      content: Autocomplete<Partner>(
        optionsBuilder: (TextEditingValue textValue) {
          final partnersList = [Partner.empty()];
          return partnersList
              .where((Partner suggestion) => suggestion.name
                  .toLowerCase()
                  .contains(textValue.text.toLowerCase()))
              .toList();
        },
        displayStringForOption: (Partner option) => option.name,
        onSelected: (Partner selectedValue) {},
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
                decoration: CustomStyle.customContainerDecoration,
                //width: constraints.biggest.width,
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
        fieldViewBuilder: (BuildContext context,
            TextEditingController textEditingController,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted) {
          return Container(
            height: 40,
            child: TextFormField(
              cursorColor: CustomColor.active,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 8),
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
                            textEditingController.clear();
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
              controller: textEditingController,
              focusNode: focusNode,
              style: CustomStyle.bodyText,
              onChanged: (String value) {
                // setState(() {
                //   widget.onValueChanged(value);
                // });
              },
              onFieldSubmitted: (String value) {
                onFieldSubmitted();
              },
            ),
          );
        },
      ),
    );
  }
}
