// import 'package:erp_frontend_v2/models/item/item_model.dart';
// import 'package:flutter/material.dart';

// import '../../constants/style.dart';

// class ItemSearchWidget extends StatefulWidget {
//   const ItemSearchWidget({
//     super.key,
//     required this.labelText,
//     required this.hintText,
//     required this.onValueChanged,
//     required this.itemsList,
//   });
//   final String labelText;
//   final String? hintText;
//   final Function(String) onValueChanged;
//   final List<Item> itemsList;

//   @override
//   State<ItemSearchWidget> createState() => _ItemSearchWidgetState();
// }

// class _ItemSearchWidgetState extends State<ItemSearchWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(widget.labelText, style: CustomStyle.labelText),
//         const SizedBox(height: 4),
//         LayoutBuilder(
//           builder: (context, constraints) => Autocomplete<Item>(
//             optionsBuilder: (TextEditingValue textValue) {
//               final itemsList = widget.itemsList;
//               return itemsList
//                   .where((Item suggestion) => suggestion.name
//                       .toLowerCase()
//                       .contains(textValue.text.toLowerCase()))
//                   .toList();
//             },
//             displayStringForOption: (Item option) => option.name,
//             onSelected: (Item selectedValue) {
//               setState(() {
//                 widget.onValueChanged(selectedValue.name);
//               });
//             },
//             optionsViewBuilder: (
//               BuildContext context,
//               AutocompleteOnSelected<Item> onSelected,
//               Iterable<Item> options,
//             ) {
//               return Padding(
//                 padding: const EdgeInsets.only(top: 4.0),
//                 child: Align(
//                   alignment: Alignment.topLeft,
//                   child: Container(
//                     constraints: const BoxConstraints(
//                       maxHeight: 300.0,
//                     ),
//                     decoration: CustomStyle.customContainerDecoration,
//                     width: constraints.biggest.width,
//                     child: Material(
//                       borderRadius: CustomStyle.customBorderRadius,
//                       color: CustomColor.white,
//                       child: ListView(
//                         shrinkWrap: true,
//                         children: options.map((Item option) {
//                           return ListTile(
//                             hoverColor: CustomColor.lightest,
//                             title: Text(option.name),
//                             onTap: () {
//                               onSelected(option);
//                             },
//                           );
//                         }).toList(),
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             },
//             fieldViewBuilder: (BuildContext context,
//                 TextEditingController textEditingController,
//                 FocusNode focusNode,
//                 VoidCallback onFieldSubmitted) {
//               return Container(
//                 height: 40,
//                 child: TextFormField(
//                   cursorColor: CustomColor.active,
//                   decoration: InputDecoration(
//                     contentPadding: EdgeInsets.symmetric(horizontal: 8),
//                     hintText: widget.hintText,
//                     enabledBorder: OutlineInputBorder(
//                       borderSide: const BorderSide(
//                         color: CustomColor.light,
//                         width: 1,
//                       ),
//                       borderRadius: CustomStyle.customBorderRadius,
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: const BorderSide(
//                         color: CustomColor.active,
//                         width: 1.5,
//                       ),
//                       borderRadius: CustomStyle.customBorderRadius,
//                     ),
//                     suffixIcon: textEditingController.text.isNotEmpty
//                         ? InkWell(
//                             onTap: () {
//                               setState(() {
//                                 textEditingController.clear();
//                               });
//                             },
//                             child: const Icon(
//                               Icons.clear,
//                               color: CustomColor.dark,
//                               size: 18,
//                             ),
//                           )
//                         : null,
//                   ),
//                   controller: textEditingController,
//                   focusNode: focusNode,
//                   style: CustomStyle.bodyText,
//                   onChanged: (String value) {
//                     setState(() {
//                       widget.onValueChanged(value);
//                     });
//                   },
//                   onFieldSubmitted: (String value) {
//                     onFieldSubmitted();
//                   },
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
