// import 'package:erp_frontend_v2/constants/style.dart';
// import 'package:erp_frontend_v2/models/partner/partner_type_model.dart';
// import 'package:erp_frontend_v2/widgets/custom_dropdown.dart';
// import 'package:erp_frontend_v2/widgets/custom_text_field.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../../providers/partner_provider.dart';
// import '../partners_autocomplete.dart';

// class FilterSectionLargePartner extends ConsumerStatefulWidget {
//   final void Function(String taxId, String name, String type) onChanged;

//   final void Function() onPressed;

//   const FilterSectionLargePartner({
//     super.key,
//     required this.onChanged,
//     required this.onPressed,
//   });

//   @override
//   ConsumerState<FilterSectionLargePartner> createState() =>
//       _FilterSectionLarge2State();
// }

// class _FilterSectionLarge2State
//     extends ConsumerState<FilterSectionLargePartner> {
//   GlobalKey<PartnerSearchWidgetState> autocompleteKey =
//       GlobalKey<PartnerSearchWidgetState>();

//   String taxId = '';
//   String name = '';
//   PartnerType type = PartnerType('');

//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery.of(context).size.width;

//     return Container(
//       decoration: CustomStyle.customContainerDecoration(),
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: CustomTextField(
//                   labelText: 'CUI',
//                   hintText: 'Cauta dupa CUI',
//                   initialValue: taxId,
//                   enabled: true,
//                   onValueChanged: (String value) {
//                     if (value.isEmpty) {
//                       taxId = '';
//                     } else {
//                       taxId = value;
//                     }

//                     widget.onChanged(name, type.name, taxId);
//                   },
//                 ),
//               ),
//               SizedBox(
//                 width: width / 64,
//               ),
//               Expanded(
//                 child: CustomTextField(
//                   labelText: 'Nume',
//                   hintText: 'Cauta dupa nume',
//                   initialValue: name,
//                   enabled: true,
//                   onValueChanged: (String value) {
//                     if (value.isEmpty) {
//                       name = '';
//                     } else {
//                       name = value;
//                     }

//                     widget.onChanged(name, type.name, taxId);
//                   },
//                 ),
//               ),
//               SizedBox(
//                 width: width / 64,
//               ),
//               Expanded(
//                 flex: 2,
//                 child: CustomDropdown(
//                   labelText: 'Tip Partener *',
//                   hintText: 'Cauta dupa tip partener',
//                   onValueChanged: (value) {
//                     setState(() {
//                       type = (value as dynamic);
//                       widget.onChanged(name, type.name, taxId);
//                     });
//                   },
//                   dataList: PartnerType.partnerTypes,
//                   initialValue: type,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(
//             height: 24,
//           ),
//           Row(
//             children: [
//               SizedBox(
//                 height: 35,
//                 child: ElevatedButton.icon(
//                   style: CustomStyle.activeButton,
//                   onPressed: () {
//                     widget.onPressed();
//                   },
//                   icon: const Icon(
//                     Icons.search_outlined,
//                     color: Colors.white,
//                   ),
//                   label: const Text(
//                     'Cauta',
//                     style: CustomStyle.primaryButtonText,
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 width: 8,
//               ),
//               TextButton(
//                 onPressed: () {
//                   setState(() {
//                     taxId = '';
//                     name = '';
//                     type = PartnerType('');
//                   });
//                   widget.onChanged(name, type.name, taxId);
//                   widget.onPressed();
//                 },
//                 style: CustomStyle.tertiaryButton,
//                 child: Text('Clear', style: CustomStyle.tertiaryButtonText),
//               )
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
