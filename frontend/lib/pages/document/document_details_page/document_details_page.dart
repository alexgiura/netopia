import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/models/document/document_transaction_model.dart';
import 'package:erp_frontend_v2/pages/document/document_add_item/document_add_item_popup.dart';
import 'package:erp_frontend_v2/pages/document/document_details_page/widgets/document_details_data_table.dart';
import 'package:erp_frontend_v2/pages/document/document_details_page/widgets/document_details_production_note_data_table.dart';
import 'package:erp_frontend_v2/pages/document/document_generate_popup/document_generate_popup.dart';
import 'package:erp_frontend_v2/providers/document_providers.dart';
import 'package:erp_frontend_v2/providers/document_transaction_provider.dart';
import 'package:erp_frontend_v2/routing/router.dart';
import 'package:erp_frontend_v2/widgets/buttons/primary_button.dart';
import 'package:erp_frontend_v2/widgets/buttons/tertiary_button.dart';
import 'package:erp_frontend_v2/widgets/custom_header_widget.dart';
import 'package:erp_frontend_v2/widgets/custom_text_field_1.dart';
import 'package:erp_frontend_v2/widgets/not_used_widgets/custom_search_dropdown.dart';
import 'package:erp_frontend_v2/widgets/custom_search_dropdown.dart';
import 'package:erp_frontend_v2/widgets/custom_text_field.dart';
import 'package:erp_frontend_v2/widgets/dialog_widgets/custom_error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
//
  final TextEditingController textController1 = TextEditingController();

  final GlobalKey<CustomTextFieldState> formKey2 =
      GlobalKey<CustomTextFieldState>();

//

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // // Extracting 'hId' from the current route
    // final uri = Uri.parse(GoRouter.of(context).location);
    // final newHId = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : null;

    // // Check if the 'hId' has changed and if so, update the state
    // if (newHId != null && newHId != _hId) {
    //   setState(() {
    //     _hId = newHId;
    //   });
    // }
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
            //extra: {'document': row.value}
          );
          setState(() {});

          showSnackBar(
              context, 'Document saved successfully!', SnackBarType.success);
          setState(() {
            _hId = result;
          });
        }
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          behavior: SnackBarBehavior.floating, // Move SnackBar to top
          backgroundColor: Colors.red, // Change background color
        ),
      );
      setState(() {
        _actionLoading = false;
        //validateOnSave = false;
      });
    }
  }

  Future<void> _deleteDocument(String hId, bool deleteGenerated) async {
    setState(() {
      _actionLoading = true;
    });
    try {
      final documentService = DocumentService();
      final String result2 = await documentService.deleteDocument(
          hId: hId, deleteGenerated: deleteGenerated);

      if (!mounted) return; // Check if the widget is still in the widget tree

      setState(() {
        _actionLoading = false;
      });

      if (result2.isNotEmpty) {
        showSnackBar(
            context, 'Document deleted successfully!', SnackBarType.success);

        ref.read(documentProvider.notifier).refreshDocuments();
        Navigator.of(context).pop();
      }
    } catch (error) {
      if (!mounted) return; // Check again after the async gap

      showErrorDialog(context, error.toString(), () {
        if (mounted) {
          _deleteDocument(_hId.toString(), true);
        }
      });

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
      color: CustomColor.white,
      padding: EdgeInsets.only(
        left: ResponsiveWidget.isSmallScreen(context) ? 0 : 24,
        right: ResponsiveWidget.isSmallScreen(context) ? 0 : 24,
        top: ResponsiveWidget.isSmallScreen(context) ? 56 : 32,
        bottom: ResponsiveWidget.isSmallScreen(context) ? 0 : 24,
      ),
      child: _initLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                // Main content (always visible)
                _buildPageContent(width, filteredTransactionList),

                // Loading overlay (visible when _isLoading is true)
                if (_actionLoading)
                  const Positioned.fill(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            ),
    );
  }

  Widget _buildPageContent(
      double width, List<DocumentTransaction> filteredTransactionList) {
    // Calculating the sums
    double sumNet = _document.documentItems
        .fold(0.0, (sum, item) => sum + (item.amountNet ?? 0));
    double sumVat = _document.documentItems
        .fold(0.0, (sum, item) => sum + (item.amountVat ?? 0));
    double sumGross = _document.documentItems
        .fold(0.0, (sum, item) => sum + (item.amountGross ?? 0));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            CustomHeader(
              title: widget.pageTitle,
              hasBackIcon: true,
            ),
            const Spacer(),
            _hId == '0'
                ? SizedBox(
                    height: 35,
                    child: ElevatedButton.icon(
                      style: CustomStyle.activeButton,
                      onPressed: () {
                        if (formKey2.currentState!.valid()) {
                          _saveDocument(_document);
                        }
                      },
                      icon: const Icon(
                        Icons.save,
                        color: CustomColor.white,
                      ),
                      label: const Text(
                        'Salveaza',
                        style: CustomStyle.primaryButtonText,
                      ),
                    ),
                  )
                : Row(
                    children: [
                      SizedBox(
                        height: 35,
                        child: ElevatedButton.icon(
                          style: CustomStyle.activeButton,
                          onPressed: () async {
                            await PdfDocument.generate(_document, ref)
                                .then((value) {
                              final blob =
                                  html.Blob([value], 'application/pdf');
                              final url =
                                  html.Url.createObjectUrlFromBlob(blob);

                              html.window.open(url, '_blank');
                            });
                          },
                          icon: const Icon(Icons.print),
                          label: const Text('Printeaza'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Visibility(
                        visible: true,
                        child: SizedBox(
                          height: 35,
                          child: ElevatedButton.icon(
                            style: CustomStyle.negativeButton,
                            onPressed: () {
                              _deleteDocument(_hId.toString(), false);
                            },
                            icon: const Icon(Icons.clear),
                            label: const Text('Anuleaza'),
                          ),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
        const SizedBox(height: 48),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CustomTextField1(
                        key: formKey2,
                        labelText: "Număr",
                        hintText: "Număr document",
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
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: CustomTextField1(
                          labelText: "Serie (Opțional)",
                          hintText: "Serie document",
                          initialValue: _document.series,
                          onValueChanged: (String value) {
                            _document.series = value;
                          }),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: DatePickerWidget(
                        initialValue:
                            DateTime.tryParse(_document.date) ?? DateTime.now(),
                        labelText: 'Dată',
                        onDateChanged: (DateTime value) {
                          _document.date =
                              DateFormat('yyyy-MM-dd').format(value);
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
                      child: SearchDropDown(
                        initialValue: _document.partner,
                        labelText: 'Partener',
                        onValueChanged: (value) {
                          setState(() {
                            _document.partner = value;
                          });
                        },
                        provider: partnerProvider,
                        errorText: "Camp obligatoriu",
                        enabled: _hId == '0',
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: CustomTextField1(
                          labelText: "Observații (Opțional)",
                          hintText: "",
                          initialValue: _document.notes,
                          onValueChanged: (String value) {
                            _document.notes = value;
                          }),
                    ),
                  ],
                )
              ],
            )),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        _hId == '0' && _document.documentType.id != 8
            ? Row(
                children: [
                  TertiaryButton(
                    text: 'Adaugă Produs',
                    icon: Icons.add,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AddItemPopup(
                            onSave: (newItem) {
                              setState(() {
                                _document.documentItems.add(newItem);
                              });
                            },
                          );
                        },
                      );
                    },
                  ),
                  const Spacer(),
                  filteredTransactionList.length > 0
                      ? PrimaryButton(
                          text: 'Generează',
                          icon: Icons.download_rounded,
                          onPressed: () {
                            //form key validator was removed
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return DocumentGeneratePopup(
                                  partnerId: _document.partner!.id!,
                                  date: _document.date,
                                  filteredTransactionList:
                                      filteredTransactionList,
                                  onSave: (itemList, transactionId) {
                                    setState(
                                      () {
                                        _document.documentItems
                                            .addAll(itemList);
                                        _transactionId = transactionId;
                                      },
                                    );
                                  },
                                );
                              },
                            );
                          },
                        )
                      : const SizedBox.shrink(),
                ],
              )
            : const SizedBox.shrink(),
        const SizedBox(
          height: 8,
        ),
        Expanded(
            child: (_document.documentType.id == 1 ||
                    _document.documentType.id == 2)
                ? DocumentItemsDataTable(
                    data: _document.documentItems,
                    readOnly: _hId != '0',
                    onUpdate: (updatedItems) {
                      setState(() {
                        _document.documentItems = updatedItems;
                      });
                    },
                  )
                : _document.documentType.id == 8
                    ? DocumentItemsProductionNote(
                        data: _document.documentItems,
                        documentTypeId: widget.documentTypeId,
                        onUpdate: (updatedItems) {
                          _document.documentItems = updatedItems;
                        },
                        // partner: _document.partner!,
                        date: _document.date,
                      )
                    : DocumentItemsDataTable(
                        data: _document.documentItems,
                        readOnly: _hId != '0',
                        onUpdate: (updatedItems) {
                          _document.documentItems = updatedItems;
                        },
                        noPrice: true,
                      )),
        (_document.documentType.id == 1 || _document.documentType.id == 2)
            ? Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .end, // Aligns the container to the right
                  children: [
                    Container(
                      width: width / 4,
                      padding: const EdgeInsets.fromLTRB(
                          24, 16, 24, 16), // Padding inside the container
                      decoration: CustomStyle.customContainerDecoration(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Subtotal:',
                                  style: CustomStyle.bodyText),
                              Text('${sumNet.toStringAsFixed(2)} RON',
                                  style: CustomStyle.bodyText),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total TVA:',
                                  style: CustomStyle.bodyText),
                              Text('${sumVat.toStringAsFixed(2)} RON',
                                  style: CustomStyle.bodyText),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Divider(),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total:',
                                  style: CustomStyle.bodyTextBold),
                              Text('${sumGross.toStringAsFixed(2)} RON',
                                  style: CustomStyle.bodyTextBold),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox.shrink()
      ],
    );
  }
}
