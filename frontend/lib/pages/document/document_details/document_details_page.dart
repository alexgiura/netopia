import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/models/document/document_transaction_model.dart';
import 'package:erp_frontend_v2/pages/document/document_add_item/add_item_popup.dart';
import 'package:erp_frontend_v2/pages/document/document_details/widgets/document_details_data_table.dart';
import 'package:erp_frontend_v2/pages/document/document_generate_popup/document_generate_popup.dart';
import 'package:erp_frontend_v2/pages/document/documents_page/widgets/eFactura_widget.dart';
import 'package:erp_frontend_v2/providers/document_providers.dart';
import 'package:erp_frontend_v2/providers/document_transaction_provider.dart';
import 'package:erp_frontend_v2/routing/router.dart';
import 'package:erp_frontend_v2/routing/routes.dart';
import 'package:erp_frontend_v2/widgets/buttons/primary_button.dart';
import 'package:erp_frontend_v2/widgets/buttons/tertiary_button.dart';
import 'package:erp_frontend_v2/widgets/custom_header_widget.dart';
import 'package:erp_frontend_v2/widgets/custom_text_field_1.dart';
import 'package:erp_frontend_v2/widgets/dialog_widgets/custom_toast.dart';
import 'package:erp_frontend_v2/widgets/dialog_widgets/warning_dialog.dart';
import 'package:erp_frontend_v2/widgets/not_used_widgets/custom_search_dropdown.dart';
import 'package:erp_frontend_v2/widgets/custom_search_dropdown.dart';
import 'package:erp_frontend_v2/widgets/custom_text_field.dart';
import 'package:erp_frontend_v2/widgets/not_used_widgets/custom_error_dialog.dart';
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

  // String? _hId = '0';

  bool _isLoading = false;
  Document _document = Document.empty();
  int _transactionId = 0;

  @override
  void initState() {
    super.initState();
    if (widget.hId == '0') {
      _document.documentType.id = widget.documentTypeId;
      _document.date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    } else {
      _fetchDocument(widget.hId);
    }
  }

  Future<void> _fetchDocument(documentId) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final documentService = DocumentService();

      final document =
          await documentService.getDocumentById(documentId: documentId);

      setState(() {
        _document = document;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = true;
      });
    }
  }

  Future<void> _saveDocument(Document doc) async {
    try {
      final documentService = DocumentService();

      final saveFuture = documentService.saveDocument(
        document: doc,
        transactionId: _transactionId,
      );
      final delayFuture = Future.delayed(const Duration(seconds: 1));

      final result = await Future.wait([saveFuture, delayFuture])
          .then((results) => results[0] as Document);

      if (context.mounted) {
        ref.read(documentProvider.notifier).refreshDocuments();
        final routeName =
            getDetailsRouteNameByDocumentType(widget.documentTypeId);
        context.goNamed(
          routeName,
          pathParameters: {'id1': result.hId!},
        );
        setState(() {
          _document = result;
        });

        showToast('success_save_document'.tr(context), ToastType.success);
      }
    } catch (error) {
      showToast('error_try_again'.tr(context), ToastType.error);
    }
  }

  Future<void> _deleteDocument(
      String hId, bool deleteGenerated, BuildContext dialogContext) async {
    try {
      final documentService = DocumentService();
      final deleteFuture = documentService.deleteDocument(
        hId: hId,
        deleteGenerated: deleteGenerated,
      );
      final delayFuture = Future.delayed(const Duration(seconds: 1));

      final result = await Future.wait([deleteFuture, delayFuture])
          .then((results) => results[0] as String);

      if (context.mounted) {
        if (result.isNotEmpty) {
          ref.read(documentProvider.notifier).refreshDocuments();
          Navigator.of(dialogContext).pop();
          Navigator.of(context).pop();

          showToast('success_cancel_document'.tr(context), ToastType.success);
        }
      }
    } catch (error) {
      if (context.mounted) {
        Navigator.of(dialogContext).pop();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return WarningCustomDialog(
              type: WarningType.error,
              title: 'error'.tr(context),
              subtitle: error.toString(),
              primaryButtonText: 'cancel_all'.tr(context),
              asyncPrimaryButtonAction: () async {
                await _deleteDocument(_document.hId!, true, context);
              },
              secondaryButtonText: 'close'.tr(context),
              secondaryButtonAction: () {
                Navigator.of(context).pop();
              },
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<DocumentTransaction> filteredTransactionList = widget.hId == '0'
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
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTitle(),
          const SizedBox(height: 16),
          _isLoading == true
              ? const Expanded(
                  child: Center(child: CircularProgressIndicator()))
              : Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_document.hId == null) ...[
                        _buildNewDocumentForm(),
                        Gap(32),
                      ],
                      _document.hId == null
                          ? _buildNewDocumentDetails()
                          : _buildDocumentDetails()
                    ],
                  ),
                ),
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
        if (_document.isDeleted != true)
          widget.hId == '0' || widget.hId.isEmpty
              ? PrimaryButton(
                  text: 'save'.tr(context),
                  icon: Icons.save,
                  asyncOnPressed: () async {
                    if (_documentDetailsFormKey.currentState!.validate()) {
                      await _saveDocument(_document);
                    }
                  },
                )
              : Row(
                  children: [
                    if ([2, 4, 5].contains(widget.documentTypeId))
                      PrimaryButton(
                        text: 'export'.tr(context),
                        icon: Icons.file_download_outlined,
                        onPressed: () async {
                          await PdfDocument.generate(_document, ref)
                              .then((value) {
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
                      asyncOnPressed: () async {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return WarningCustomDialog(
                              type: WarningType.warning,
                              title: 'cancel_confirmation'.tr(context),
                              subtitle:
                                  'cancel_confirmation_description'.tr(context),
                              primaryButtonText: 'cancel'.tr(context),
                              asyncPrimaryButtonAction: () async {
                                await _deleteDocument(
                                    _document.hId!, false, context);
                              },
                              secondaryButtonText: 'close'.tr(context),
                              secondaryButtonAction: () {
                                Navigator.of(context).pop();
                              },
                            );
                          },
                        );
                      },
                      style: CustomStyle.negativeButton,
                    )
                  ],
                ),
      ],
    );
  }

  Widget _buildNewDocumentForm() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      decoration: CustomStyle.customContainerDecoration(border: true),
      child: Form(
        key: _documentDetailsFormKey,
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
                    enabled: _document.hId == null,
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

  Widget _buildNewDocumentDetails() {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        decoration: CustomStyle.customContainerDecoration(border: true),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
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
                      style:
                          CustomStyle.regular14(color: CustomColor.greenGray),
                    ),
                  ],
                ),
                const Spacer(),
                if (_document.documentItems.isNotEmpty)
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
              ],
            ),
            Gap(24),
            if (_document.documentItems.isEmpty && _document.hId == null)
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
              Flexible(
                child: DocumentItemsDataTable(
                  documentTypeId: _document.documentType.id,
                  data: _document.documentItems,
                  readOnly: _document.hId != null,
                  onUpdate: (updatedItems) {
                    setState(() {
                      _document.documentItems = updatedItems;
                    });
                  },
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentDetails() {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        decoration: CustomStyle.customContainerDecoration(border: true),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '#${_document.number}',
                    style: CustomStyle.bold32(color: CustomColor.textPrimary),
                  ),
                  if (_document.series != null && _document.series != '') ...[
                    Text(
                      ' / ',
                      style: CustomStyle.medium32(color: CustomColor.slate_400),
                    ),
                    Text(
                      _document.series!,
                      style: CustomStyle.bold32(color: CustomColor.greenGray),
                    ),
                  ],
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
                  if (_document.documentType.id == 2) ...[
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${'e_factura'.tr(context)}:',
                          style: CustomStyle.regular14(
                              color: CustomColor.greenGray),
                        ),
                        eFacturaStatus(_document, context)
                      ],
                    ),
                    Gap(40),
                  ],
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${'partner'.tr(context)}:',
                        style:
                            CustomStyle.regular14(color: CustomColor.greenGray),
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
                        '${'document_date'.tr(context)}:',
                        style:
                            CustomStyle.regular14(color: CustomColor.greenGray),
                      ),
                      Text(
                        _document.date,
                        style: CustomStyle.bold16(),
                      ),
                    ],
                  ),
                  if (_document.notes != null) ...[
                    Gap(40),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${'notes'.tr(context)}:',
                          style: CustomStyle.regular14(
                              color: CustomColor.greenGray),
                        ),
                        Text(
                          _document.notes!,
                          style: CustomStyle.bold16(),
                        ),
                      ],
                    ),
                  ]
                ],
              ),
            ),
            Gap(24),
            if (_document.documentItems.isEmpty && _document.hId == null)
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
              Flexible(
                child: DocumentItemsDataTable(
                  documentTypeId: _document.documentType.id,
                  data: _document.documentItems,
                  readOnly: _document.hId != null,
                  onUpdate: (updatedItems) {
                    setState(() {
                      _document.documentItems = updatedItems;
                    });
                  },
                ),
              )
          ],
        ),
      ),
    );
  }
}
