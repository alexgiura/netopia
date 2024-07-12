import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/models/document/document_transaction_model.dart';
import 'package:erp_frontend_v2/pages/document/document_add_item/add_item_popup.dart';
import 'package:erp_frontend_v2/pages/document/document_details_page/widgets/document_details_data_table.dart';
import 'package:erp_frontend_v2/pages/document/document_details_page/widgets/document_details_production_note_data_table.dart';
import 'package:erp_frontend_v2/pages/document/document_generate_popup/document_generate_popup.dart';
import 'package:erp_frontend_v2/providers/document_providers.dart';
import 'package:erp_frontend_v2/providers/document_transaction_provider.dart';
import 'package:erp_frontend_v2/routing/router.dart';
import 'package:erp_frontend_v2/routing/routes.dart';
import 'package:erp_frontend_v2/widgets/buttons/primary_button.dart';
import 'package:erp_frontend_v2/widgets/buttons/tertiary_button.dart';
import 'package:erp_frontend_v2/widgets/custom_header_widget.dart';
import 'package:erp_frontend_v2/widgets/custom_text_field_1.dart';
import 'package:erp_frontend_v2/widgets/dialog_widgets/custom_toast.dart';
import 'package:erp_frontend_v2/widgets/not_used_widgets/custom_search_dropdown.dart';
import 'package:erp_frontend_v2/widgets/custom_search_dropdown.dart';
import 'package:erp_frontend_v2/widgets/custom_text_field.dart';
import 'package:erp_frontend_v2/widgets/dialog_widgets/custom_error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../pdf/pdf_document.dart';
import '../../../constants/style.dart';
import '../../../utils/responsiveness.dart';
import '../../../models/document/document_model.dart';
import '../../../providers/partner_provider.dart';
import '../../../services/document.dart';
import '../../../utils/customSnackBar.dart';
import '../../../widgets/custom_date_picker.dart';
import 'dart:html' as html;

class DocumentDetailsPage extends ConsumerStatefulWidget {
  final String hId;
  final int documentTypeId;
  final String pageTitle;

  const DocumentDetailsPage({
    super.key,
    required this.hId,
    required this.documentTypeId,
    required this.pageTitle,
  });

  @override
  ConsumerState<DocumentDetailsPage> createState() =>
      _DocumentDetailsPageState();
}

class _DocumentDetailsPageState extends ConsumerState<DocumentDetailsPage> {
  final GlobalKey<FormState> _documentDetailsFormKey = GlobalKey<FormState>();

  String _hId = '0';

  bool _initLoading = false;
  bool _actionLoading = false;
  Document _document = Document.empty();
  int _transactionId = 0;

  @override
  void initState() {
    super.initState();

    _hId = widget.hId;
    if (_hId != '0') {
      _fetchDocument();
    } else {
      _document.documentType.id = widget.documentTypeId;
      _document.date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    }
  }

  Future<void> _fetchDocument() async {
    setState(() {
      _initLoading = true;
    });
    try {
      final documentService = DocumentService();

      final document = await documentService.getDocumentById(documentId: _hId);

      setState(() {
        _document = document;
        _initLoading = false;
      });
    } catch (error) {
      setState(() {
        _initLoading = false;
      });
    }
  }

  Future<void> _saveDocument(Document doc) async {
    setState(() {
      _actionLoading = true;
    });

    try {
      final documentService = DocumentService();
      final String result = await documentService.saveDocument(
          document: doc, transactionId: _transactionId);

      setState(() {
        _actionLoading = false;
      });

      if (result.isNotEmpty) {
        if (context.mounted) {
          final routeName =
              getDetailsRouteNameByDocumentType(widget.documentTypeId);
          context.goNamed(
            routeName,
            pathParameters: {'id1': result},
          );

          showToast('success_save_document'.tr(context), ToastType.success);
          setState(() {
            _hId = result;
          });
        }
      }
    } catch (error) {
      showToast('error'.tr(context), ToastType.error);
      setState(() {
        _actionLoading = false;
      });
    }
  }

  Future<void> _deleteDocument(String hId, bool deleteGenerated) async {
    setState(() {
      _actionLoading = true;
    });
    try {
      final documentService = DocumentService();
      final String result = await documentService.deleteDocument(
          hId: hId, deleteGenerated: deleteGenerated);

      if (!mounted) return; // Check if the widget is still in the widget tree

      setState(() {
        _actionLoading = false;
      });

      if (result.isNotEmpty) {
        showToast('success_cancel_document'.tr(context), ToastType.success);

        ref.read(documentProvider.notifier).refreshDocuments();
        Navigator.of(context).pop();
      }
    } catch (error) {
      showToast('error'.tr(context), ToastType.error);

      setState(() {
        _actionLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    List<DocumentTransaction> filteredTransactionList = _hId == '0'
        ? (ref.watch(documentTransactionProvider).value ?? [])
            .where((transaction) {
            return transaction.documentTypeDestinationId ==
                widget.documentTypeId;
          }).toList()
        : [];

    return Container(
      padding: EdgeInsets.only(
        left: ResponsiveWidget.isSmallScreen(context) ? 0 : 24,
        right: ResponsiveWidget.isSmallScreen(context) ? 0 : 24,
        top: ResponsiveWidget.isSmallScreen(context) ? 24 : 32,
        bottom: ResponsiveWidget.isSmallScreen(context) ? 0 : 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
          const SizedBox(height: 16),
          if (_hId == '0') ...[
            _buildDocumentHeader(),
            Gap(32),
          ],
          _buildDocumentDetails()
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Row(
      children: [
        CustomHeader(
          title: widget.pageTitle,
          hasBackIcon: true,
        ),
        const Spacer(),
        _hId == '0'
            ? PrimaryButton(
                text: 'save'.tr(context),
                icon: Icons.save,
                onPressed: () {
                  if (_documentDetailsFormKey.currentState!.validate()) {
                    _saveDocument(_document);
                  }
                },
              )
            : Row(
                children: [
                  PrimaryButton(
                    text: 'export'.tr(context),
                    icon: Icons.file_download_outlined,
                    onPressed: () async {
                      await PdfDocument.generate(_document, ref).then((value) {
                        final blob = html.Blob([value], 'application/pdf');
                        final url = html.Url.createObjectUrlFromBlob(blob);

                        html.window.open(url, '_blank');
                      });
                    },
                    style: CustomStyle.neutralButton,
                  ),
                  const SizedBox(width: 16),
                  PrimaryButton(
                    text: 'cancel'.tr(context),
                    icon: Icons.delete_outline_rounded,
                    onPressed: () {
                      if (_documentDetailsFormKey.currentState!.validate()) {
                        _saveDocument(_document);
                      }
                    },
                    style: CustomStyle.negativeButton,
                  )
                ],
              ),
      ],
    );
  }

  Widget _buildDocumentHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      decoration: CustomStyle.customContainerDecoration(border: true),
      child: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'document_details'.tr(context),
              style: CustomStyle.medium20(),
            ),
            Gap(24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: CustomTextField1(
                      labelText: 'number'.tr(context),
                      hintText: 'document_number_hint'.tr(context),
                      initialValue: _document.number,
                      onValueChanged: (String value) {
                        _document.number = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'error_required_field'.tr(context);
                        }
                        return null;
                      },
                      required: true,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: CustomTextField1(
                        labelText: 'series'.tr(context),
                        hintText: 'document_series_hint'.tr(context),
                        initialValue: _document.series,
                        onValueChanged: (String value) {
                          _document.series = value;
                        }),
                  ),
                ),
                Expanded(
                  child: DatePickerWidget(
                    initialValue:
                        DateTime.tryParse(_document.date) ?? DateTime.now(),
                    labelText: 'date'.tr(context),
                    onDateChanged: (DateTime value) {
                      _document.date = DateFormat('yyyy-MM-dd').format(value);
                    },
                    enabled: _hId == '0',
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: SearchDropDown(
                      initialValue: _document.partner,
                      labelText: 'partner'.tr(context),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'error_required_field'.tr(context);
                        }
                        return null;
                      },
                      onValueChanged: (value) {
                        setState(() {
                          _document.partner = value;
                        });
                      },
                      provider: partnerProvider,
                      required: true,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: CustomTextField1(
                      labelText: 'notes'.tr(context),
                      initialValue: _document.notes,
                      onValueChanged: (String value) {
                        _document.notes = value;
                      }),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentDetails() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      decoration: CustomStyle.customContainerDecoration(border: true),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _hId == '0'
              ? Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'included_products'.tr(context),
                          style: CustomStyle.medium20(),
                        ),
                        Text(
                          'included_products_description'.tr(context),
                          style: CustomStyle.regular14(
                              color: CustomColor.greenGray),
                        ),
                      ],
                    ),
                    const Spacer(),
                    if (_document.documentItems.isNotEmpty &&
                        _document.hId == '0')
                      PrimaryButton(
                        text: 'add'.tr(context),
                        icon: Icons.add,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AddItemPopup(
                                callback: (documentItems) {
                                  setState(() {
                                    _document.documentItems
                                        .addAll(documentItems);
                                  });
                                },
                              );
                            },
                          );
                        },
                      ),
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        _document.series ?? '',
                        style: CustomStyle.bold32(),
                      ),
                      Gap(16),
                      Text(
                        '#',
                        style:
                            CustomStyle.medium32(color: CustomColor.greenGray),
                      ),
                      Text(
                        _document.number,
                        style:
                            CustomStyle.medium32(color: CustomColor.greenGray),
                      ),
                      Gap(16),
                      Container(
                        alignment: Alignment.center,
                        child: Container(
                          height: 28,
                          width: 70,
                          decoration: BoxDecoration(
                            color: _document.isDeleted == true
                                ? CustomColor.error.withOpacity(0.1)
                                : CustomColor.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child: Text(
                                _document.isDeleted == true
                                    ? 'canceled_masculin'.tr(context)
                                    : 'valid_masculin'.tr(context),
                                style: _document.isDeleted == true
                                    ? CustomStyle.semibold14(
                                        color: CustomColor.error)
                                    : CustomStyle.semibold14(
                                        color: CustomColor.green)),
                          ),
                        ),
                      ),
                      Spacer(),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Partener:',
                            style: CustomStyle.regular14(
                                color: CustomColor.greenGray),
                          ),
                          Text(
                            _document.partner!.name,
                            style: CustomStyle.bold16(),
                          ),
                        ],
                      ),
                      Gap(40),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Data document:',
                            style: CustomStyle.regular14(
                                color: CustomColor.greenGray),
                          ),
                          Text(
                            _document.date,
                            style: CustomStyle.bold16(),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
          Gap(24),
          if (_document.documentItems.isEmpty && _hId == '0')
            PrimaryButton(
              text: 'add'.tr(context),
              icon: Icons.add,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AddItemPopup(
                      callback: (documentItems) {
                        setState(() {
                          _document.documentItems.addAll(documentItems);
                        });
                      },
                    );
                  },
                );
              },
            ),
          if (_document.documentItems.isNotEmpty)
            (_document.documentType.id == 8)
                ? DocumentItemsProductionNote(
                    data: _document.documentItems,
                    documentTypeId: widget.documentTypeId,
                    onUpdate: (updatedItems) {
                      _document.documentItems = updatedItems;
                    },
                    date: _document.date,
                  )
                : DocumentItemsDataTable(
                    documentTypeId: _document.documentType.id,
                    data: _document.documentItems,
                    readOnly: _hId != '0',
                    onUpdate: (updatedItems) {
                      setState(() {
                        _document.documentItems = updatedItems;
                      });
                    },
                  )
        ],
      ),
    );
  }
}
