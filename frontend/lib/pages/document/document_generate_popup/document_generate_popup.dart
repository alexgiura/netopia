import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/models/document/document_generate_model.dart';
import 'package:erp_frontend_v2/models/document/document_model.dart';
import 'package:erp_frontend_v2/models/document/document_transaction_model.dart';
import 'package:erp_frontend_v2/pages/document/document_generate_popup/widgets/document_generate_data_table.dart';
import 'package:erp_frontend_v2/services/document.dart';
import 'package:erp_frontend_v2/widgets/buttons/primary_button.dart';
import 'package:erp_frontend_v2/widgets/buttons/tertiary_button.dart';
import 'package:erp_frontend_v2/widgets/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DocumentGeneratePopup extends ConsumerStatefulWidget {
  const DocumentGeneratePopup(
      {super.key,
      required this.filteredTransactionList,
      required this.onSave,
      required this.partnerId,
      required this.date});
  final void Function(List<DocumentItem>, int transactionId) onSave;
  final List<DocumentTransaction> filteredTransactionList;
  final String partnerId;
  final String date;

  @override
  ConsumerState<DocumentGeneratePopup> createState() =>
      _DocumentGeneratePopupState();
}

class _DocumentGeneratePopupState extends ConsumerState<DocumentGeneratePopup>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  List<DocumentGenerate> _docs = [];
  List<DocumentGenerate> _selectedDocList = [];

  late DocumentTransaction _documentTransaction;

  @override
  void initState() {
    super.initState();
    _documentTransaction = widget.filteredTransactionList.first;
    _isLoading = true;
    _fetchDocs();
  }

  Future<void> _fetchDocs() async {
    try {
      final documentService = DocumentService();

      final docs = await documentService.getDocumentGenerate(
          partnerId: widget.partnerId,
          date: widget.date,
          transactionId: _documentTransaction.id,
          documentTypeId: _documentTransaction.documentTypeSourceId);

      setState(() {
        _docs = docs;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<DocumentItem> generateDocumentItems(List<DocumentGenerate> documents) {
    List<DocumentItem> groupedList = [];

    for (var document in documents) {
      var index = groupedList.indexWhere(
        (documentItem) => documentItem.item.id == document.documentItem.item.id,
      );

      if (index != -1) {
        groupedList[index].quantity += document.documentItem.quantity;
        if (groupedList[index].generatedDId == null) {
          groupedList[index].generatedDId = [document.documentItem.dId!];
        } else {
          groupedList[index].generatedDId!.add(document.documentItem.dId!);
        }
      } else {
        final newDocumentItem = DocumentItem(
            item: document.documentItem.item,
            quantity: document.documentItem.quantity,
            price: 0.00,
            amountNet: 0.00,
            amountVat: 0.00,
            amountGross: 0.00,
            generatedDId: [document.documentItem.dId!]);
        // newDocumentItem.generatedDId!.add(document.documentItem.dId!);

        groupedList.add(newDocumentItem);
      }
    }

    return groupedList;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // titlePadding: EdgeInsets.fromLTRB(24, 24, 24, 16),
      contentPadding: const EdgeInsets.fromLTRB(24, 36, 24, 0),
      buttonPadding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
      // title: const Text('Genereaza Document'),
      content: Container(
        height: 600,
        width: 1000,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  "Alege o tranzacție disponibilă",
                  style: CustomStyle.tableHeaderText,
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Consumer(
                    builder: (context, watch, _) {
                      return CustomDropdown(
                        hintText: 'Alege tranzacția',
                        initialValue: _documentTransaction,
                        onValueChanged: (value) {
                          _documentTransaction = value;
                        },
                        dataList: widget.filteredTransactionList,
                      );
                    },
                  ),
                ),
                const Spacer()
              ],
            ),
            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  "Alege documentele disponibile",
                  style: CustomStyle.tableHeaderText,
                ),
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : DocumentGenerateDataTable(
                      data: _docs,
                      onSelect: (doc, value) {
                        if (value == true) {
                          _selectedDocList.add(doc);
                        } else if (value == false) {
                          _selectedDocList.remove(doc);
                        }
                      },
                    ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TertiaryButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the popup
          },
          text: 'Renunță',
        ),
        PrimaryButton(
          onPressed: () {
            if (_selectedDocList.isNotEmpty) {
              final generatedItems = generateDocumentItems(_selectedDocList);

              widget.onSave(generatedItems, _documentTransaction.id);
              Navigator.of(context).pop();
            }
          },
          text: 'Adaugă',
        ),
      ],
    );
  }
}
