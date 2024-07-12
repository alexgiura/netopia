// import 'package:erp_frontend_v2/models/app_localizations.dart';
// import 'package:erp_frontend_v2/models/document/document_transaction_model.dart';
// import 'package:erp_frontend_v2/pages/document/document_add_item/add_item_popup.dart';
// import 'package:erp_frontend_v2/pages/document/document_add_item/document_add_item_popup.dart';
// import 'package:erp_frontend_v2/pages/document/document_details_page/widgets/document_details_data_table.dart';
// import 'package:erp_frontend_v2/pages/document/document_details_page/widgets/document_details_production_note_data_table.dart';
// import 'package:erp_frontend_v2/pages/document/document_generate_popup/document_generate_popup.dart';
// import 'package:erp_frontend_v2/providers/document_providers.dart';
// import 'package:erp_frontend_v2/providers/document_transaction_provider.dart';
// import 'package:erp_frontend_v2/routing/router.dart';
// import 'package:erp_frontend_v2/routing/routes.dart';
// import 'package:erp_frontend_v2/widgets/buttons/primary_button.dart';
// import 'package:erp_frontend_v2/widgets/buttons/tertiary_button.dart';
// import 'package:erp_frontend_v2/widgets/custom_header_widget.dart';
// import 'package:erp_frontend_v2/widgets/custom_text_field_1.dart';
// import 'package:erp_frontend_v2/widgets/dialog_widgets/custom_toast.dart';
// import 'package:erp_frontend_v2/widgets/not_used_widgets/custom_search_dropdown.dart';
// import 'package:erp_frontend_v2/widgets/custom_search_dropdown.dart';
// import 'package:erp_frontend_v2/widgets/custom_text_field.dart';
// import 'package:erp_frontend_v2/widgets/dialog_widgets/custom_error_dialog.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:gap/gap.dart';
// import 'package:go_router/go_router.dart';
// import 'package:intl/intl.dart';
// import '../../../pdf/pdf_document.dart';
// import '../../../constants/style.dart';
// import '../../../utils/responsiveness.dart';
// import '../../../models/document/document_model.dart';
// import '../../../providers/partner_provider.dart';
// import '../../../services/document.dart';
// import '../../../utils/customSnackBar.dart';
// import '../../../widgets/custom_date_picker.dart';
// import 'dart:html' as html;

// class DocumentDetailsPage extends ConsumerStatefulWidget {
//   final String hId;
//   final int documentTypeId;
//   final String pageTitle;

//   const DocumentDetailsPage({
//     super.key,
//     required this.hId,
//     required this.documentTypeId,
//     required this.pageTitle,
//   });

//   @override
//   ConsumerState<DocumentDetailsPage> createState() =>
//       _DocumentDetailsPageState();
// }

// class _DocumentDetailsPageState extends ConsumerState<DocumentDetailsPage> {
//   String _hId = '0';

//   bool _initLoading = false;
//   bool _actionLoading = false;
//   Document _document = Document.empty();

//   @override
//   void initState() {
//     super.initState();

//     _hId = widget.hId;
//     _fetchDocument();
//   }

//   Future<void> _fetchDocument() async {
//     setState(() {
//       _initLoading = true;
//     });
//     try {
//       final documentService = DocumentService();

//       final document = await documentService.getDocumentById(documentId: _hId);

//       setState(() {
//         _document = document;
//         _initLoading = false;
//       });
//     } catch (error) {
//       setState(() {
//         _initLoading = false;
//       });
//     }
//   }

//   Future<void> _deleteDocument(String hId, bool deleteGenerated) async {
//     setState(() {
//       _actionLoading = true;
//     });
//     try {
//       final documentService = DocumentService();
//       final String result2 = await documentService.deleteDocument(
//           hId: hId, deleteGenerated: deleteGenerated);

//       if (!mounted) return; // Check if the widget is still in the widget tree

//       setState(() {
//         _actionLoading = false;
//       });

//       if (result2.isNotEmpty) {
//         showSnackBar(
//             context, 'Document deleted successfully!', SnackBarType.success);

//         ref.read(documentProvider.notifier).refreshDocuments();
//         Navigator.of(context).pop();
//       }
//     } catch (error) {
//       if (!mounted) return; // Check again after the async gap

//       showErrorDialog(context, error.toString(), () {
//         if (mounted) {
//           _deleteDocument(_hId.toString(), true);
//         }
//       });

//       setState(() {
//         _actionLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<DocumentTransaction> filteredTransactionList = _hId == '0'
//         ? (ref.watch(documentTransactionProvider).value ?? [])
//             .where((transaction) {
//             return transaction.documentTypeDestinationId ==
//                 widget.documentTypeId;
//           }).toList()
//         : [];

//     return Container(
//       padding: EdgeInsets.only(
//         left: ResponsiveWidget.isSmallScreen(context) ? 0 : 24,
//         right: ResponsiveWidget.isSmallScreen(context) ? 0 : 24,
//         top: ResponsiveWidget.isSmallScreen(context) ? 24 : 32,
//         bottom: ResponsiveWidget.isSmallScreen(context) ? 0 : 24,
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildTitle(),
//           const SizedBox(height: 16),
//           _buildDocumentDetails()
//         ],
//       ),
//     );
//   }

//   Widget _buildTitle() {
//     return Row(
//       children: [
//         CustomHeader(
//           title: widget.pageTitle,
//           hasBackIcon: true,
//         ),
//         const Spacer(),
//         Row(
//           children: [
//             SizedBox(
//               height: 35,
//               child: ElevatedButton.icon(
//                 style: CustomStyle.activeButton,
//                 onPressed: () async {
//                   await PdfDocument.generate(_document, ref).then((value) {
//                     final blob = html.Blob([value], 'application/pdf');
//                     final url = html.Url.createObjectUrlFromBlob(blob);

//                     html.window.open(url, '_blank');
//                   });
//                 },
//                 icon: const Icon(Icons.print),
//                 label: const Text('Printeaza'),
//               ),
//             ),
//             const SizedBox(width: 16),
//             Visibility(
//               visible: true,
//               child: SizedBox(
//                 height: 35,
//                 child: ElevatedButton.icon(
//                   style: CustomStyle.negativeButton,
//                   onPressed: () {
//                     _deleteDocument(_hId.toString(), false);
//                   },
//                   icon: const Icon(Icons.clear),
//                   label: const Text('Anuleaza'),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   // Widget _buildDocumentHeader() {
//   //   return Container(
//   //     padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
//   //     decoration: CustomStyle.customContainerDecoration(border: true),
//   //     child: Form(
//   //       child: Column(
//   //         mainAxisSize: MainAxisSize.min,
//   //         mainAxisAlignment: MainAxisAlignment.start,
//   //         crossAxisAlignment: CrossAxisAlignment.start,
//   //         children: [
//   //           Text(
//   //             'document_details'.tr(context),
//   //             style: CustomStyle.medium20(),
//   //           ),
//   //           Gap(24),
//   //           Row(
//   //             crossAxisAlignment: CrossAxisAlignment.start,
//   //             children: [
//   //               Expanded(
//   //                 child: Padding(
//   //                   padding: const EdgeInsets.only(right: 16),
//   //                   child: CustomTextField1(
//   //                     labelText: 'number'.tr(context),
//   //                     hintText: 'document_number_hint'.tr(context),
//   //                     initialValue: _document.number,
//   //                     onValueChanged: (String value) {
//   //                       _document.number = value;
//   //                     },
//   //                     validator: (value) {
//   //                       if (value!.isEmpty) {
//   //                         return 'error_required_field'.tr(context);
//   //                       }
//   //                       return null;
//   //                     },
//   //                     required: true,
//   //                   ),
//   //                 ),
//   //               ),
//   //               Expanded(
//   //                 child: Padding(
//   //                   padding: const EdgeInsets.only(right: 16),
//   //                   child: CustomTextField1(
//   //                       labelText: 'series'.tr(context),
//   //                       hintText: 'document_series_hint'.tr(context),
//   //                       initialValue: _document.series,
//   //                       onValueChanged: (String value) {
//   //                         _document.series = value;
//   //                       }),
//   //                 ),
//   //               ),
//   //               Expanded(
//   //                 child: DatePickerWidget(
//   //                   initialValue:
//   //                       DateTime.tryParse(_document.date) ?? DateTime.now(),
//   //                   labelText: 'date'.tr(context),
//   //                   onDateChanged: (DateTime value) {
//   //                     _document.date = DateFormat('yyyy-MM-dd').format(value);
//   //                   },
//   //                   enabled: _hId == '0',
//   //                 ),
//   //               ),
//   //             ],
//   //           ),
//   //           const SizedBox(
//   //             height: 8,
//   //           ),
//   //           Row(
//   //             crossAxisAlignment: CrossAxisAlignment.start,
//   //             children: [
//   //               Expanded(
//   //                 child: Padding(
//   //                   padding: const EdgeInsets.only(right: 16),
//   //                   child: SearchDropDown(
//   //                     initialValue: _document.partner,
//   //                     labelText: 'partner'.tr(context),
//   //                     validator: (value) {
//   //                       if (value!.isEmpty) {
//   //                         return 'error_required_field'.tr(context);
//   //                       }
//   //                       return null;
//   //                     },
//   //                     onValueChanged: (value) {
//   //                       setState(() {
//   //                         _document.partner = value;
//   //                       });
//   //                     },
//   //                     provider: partnerProvider,
//   //                     required: true,
//   //                   ),
//   //                 ),
//   //               ),
//   //               Expanded(
//   //                 flex: 2,
//   //                 child: CustomTextField1(
//   //                     labelText: 'notes'.tr(context),
//   //                     initialValue: _document.notes,
//   //                     onValueChanged: (String value) {
//   //                       _document.notes = value;
//   //                     }),
//   //               ),
//   //             ],
//   //           )
//   //         ],
//   //       ),
//   //     ),
//   //   );
//   // }

//   Widget _buildDocumentDetails() {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
//       decoration: CustomStyle.customContainerDecoration(border: true),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Text(
//                 _document.series ?? '',
//                 style: CustomStyle.bold32(),
//               ),
//               Text(
//                 _document.number,
//                 style: CustomStyle.medium32(color: CustomColor.greenGray),
//               ),
//               Container(
//                 alignment: Alignment.center,
//                 child: Container(
//                   height: 28,
//                   width: 70,
//                   decoration: BoxDecoration(
//                     color: _document.isDeleted == true
//                         ? CustomColor.error.withOpacity(0.1)
//                         : CustomColor.green.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(50),
//                   ),
//                   child: Center(
//                     child: Text(
//                         _document.isDeleted == true
//                             ? 'canceled_masculin'.tr(context)
//                             : 'valid_masculin'.tr(context),
//                         style: _document.isDeleted == true
//                             ? CustomStyle.semibold14(color: CustomColor.error)
//                             : CustomStyle.semibold14(color: CustomColor.green)),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           Gap(48),
//           if (_document.documentItems.isNotEmpty)
//             (_document.documentType.id == 8)
//                 ? DocumentItemsProductionNote(
//                     data: _document.documentItems,
//                     documentTypeId: widget.documentTypeId,
//                     onUpdate: (updatedItems) {
//                       _document.documentItems = updatedItems;
//                     },
//                     date: _document.date,
//                   )
//                 : DocumentItemsDataTable(
//                     documentTypeId: _document.documentType.id,
//                     data: _document.documentItems,
//                     readOnly: _hId != '0',
//                     onUpdate: (updatedItems) {
//                       setState(() {
//                         _document.documentItems = updatedItems;
//                       });
//                     },
//                   )
//         ],
//       ),
//     );
//   }
// }
