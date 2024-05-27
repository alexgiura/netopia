// import 'package:erp_frontend_v2/constants/sizes.dart';
// import 'package:erp_frontend_v2/constants/style.dart';
// import 'package:erp_frontend_v2/widgets/custom_search_bar.dart';
// import 'package:erp_frontend_v2/widgets/filters/drop_down_filter/widgets/filtered_list_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class CustomDropDown<T> extends ConsumerStatefulWidget {
//   const CustomDropDown({
//     super.key,
//     this.labelText,
//     this.enabled = true,
//     required this.onValueChanged,
//     required this.provider,
//     this.hintText,
//     this.errorText,
//     this.initialValue,
//   });
//   final String? labelText;
//   final Function(T) onValueChanged;
//   final FutureProvider<List<T>> provider;
//   final String? hintText;
//   final String? errorText;
//   final T? initialValue;
//   final bool enabled;

//   @override
//   ConsumerState<CustomDropDown<T>> createState() => CustomDropDownState<T>();
// }

// class CustomDropDownState<T> extends ConsumerState<CustomDropDown<T>> {
//   List<T> dataList = [];
//   List<T> filteredDataList = [];

//   // List<T> checkedItems = [];
//   T? selectedItem;

//   GlobalKey<FilteredListWidgetState> filteredListKey = GlobalKey();

//   // Need for overlay
//   bool isOverlayVisible = false;
//   OverlayEntry? entry;
//   final layerLink = LayerLink(); // I use to attach dropdown to textField

//   bool _showError = false;

//   @override
//   void initState() {
//     super.initState();
//     if (widget.initialValue != null) {
//       selectedItem = widget.initialValue;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final asyncDataList = ref.watch(widget.provider);

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         widget.labelText != null
//             ? Text(widget.labelText!, style: CustomStyle.labelText)
//             : Container(),
//         widget.labelText != null ? const SizedBox(height: 4) : Container(),
//         CompositedTransformTarget(
//           link: layerLink,
//           child: InkWell(
//             child: Container(
//               padding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
//               height: CustomSize.textFormFieldHeight,
//               decoration: widget.enabled
//                   ? _showError == false
//                       ? CustomStyle.customContainerDecorationNoShadow
//                       : CustomStyle.customErrorContainerDecoration
//                   : CustomStyle.customInactiveContainerDecoration,
//               child: Row(
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   Text(selectedItem != null
//                       ? (selectedItem as dynamic).name
//                       : ''),
//                   Spacer(),
//                   const Icon(
//                     Icons.expand_more_rounded,
//                     color: CustomColor.medium,
//                     size: 20,
//                   ),
//                 ],
//               ),
//             ),
//             onTap: () {
//               asyncDataList.when(
//                 data: (List<T> data) {
//                   dataList = data;
//                   filteredDataList = dataList;
//                   if (widget.enabled != false) {
//                     showOverlay();
//                   }
//                 },
//                 loading: () {},
//                 error: (error, stack) {},
//               );
//             },
//           ),
//         ),
//         // Error message
//         _showError
//             ? Padding(
//                 padding: EdgeInsets.only(top: 4),
//                 child: Text(
//                   widget.errorText ?? 'Camp obligatoriu',
//                   style: CustomStyle.errorText,
//                 ),
//               )
//             : Container(),
//       ],
//     );
//   }

//   void showOverlay() {
//     final overlay = Overlay.of(context);
//     final renderBox = context.findRenderObject() as RenderBox;
//     final size = renderBox.size;
//     entry = OverlayEntry(
//       builder: (context) => Positioned(
//         width: size.width,
//         child: CompositedTransformFollower(
//           link: layerLink,
//           showWhenUnlinked: false,
//           offset: const Offset(
//             0,
//             CustomSize.textFormFieldHeight + 4,
//           ),
//           child: buildOverlay(),
//         ),
//       ),
//     );
//     overlay.insert(entry!);
//     setState(() {
//       isOverlayVisible = true;
//     });
//   }

//   Widget buildOverlay() {
//     return TapRegion(
//       onTapOutside: (event) {
//         hideOverlay();
//       },
//       child: Container(
//           decoration: CustomStyle.customContainerDecoration,
//           constraints: const BoxConstraints(
//             maxHeight: 350.0,
//             //maxWidth: 350,
//             //minHeight: 200,
//           ),
//           child: Padding(
//             padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                         child: CustomSearchBar(
//                       hintText: 'Cauta Partener',
//                       onValueChanged: (value) {
//                         List<T> newFilteredDataList = dataList.where((item) {
//                           final name = (item as dynamic).name as String;
//                           return name
//                               .toLowerCase()
//                               .contains(value.toLowerCase());
//                         }).toList();
//                         filteredListKey.currentState
//                             ?.updateList(newFilteredDataList);
//                       },
//                       //visibleBorder: false,
//                     ))
//                   ],
//                 ),
//                 SizedBox(
//                   height: 8,
//                 ),
//                 Expanded(
//                   child: FilteredListWidget<T>(
//                     key: filteredListKey,
//                     initialDataList: filteredDataList,
//                     checkedItems: null,
//                     onItemChanged: (bool newValue, T item) {
//                       setState(() {
//                         selectedItem = item;
//                         hideOverlay();
//                         widget.onValueChanged(item);
//                         _showError = false;
//                       });
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           )),
//     );
//   }

//   void hideOverlay() {
//     entry?.remove();
//     entry = null;
//     setState(() {
//       isOverlayVisible = false;
//     });
//   }

//   void refreshOverlay() {
//     entry?.remove();
//     showOverlay();
//   }

//   bool valid() {
//     if (selectedItem == null) {
//       setState(() {
//         _showError = true;
//       });
//       return false;
//     }
//     return true;
//   }

//   //dispose
//   @override
//   void dispose() {
//     if (entry != null) {
//       entry?.remove();
//       entry = null;
//     }
//     super.dispose();
//   }
// }
