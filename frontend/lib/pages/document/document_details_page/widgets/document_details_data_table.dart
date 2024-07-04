import 'package:erp_frontend_v2/providers/partner_provider.dart';
import 'package:erp_frontend_v2/widgets/custom_data_table.dart';
import 'package:erp_frontend_v2/widgets/not_used_widgets/custom_document_drop_down.dart';
import 'package:erp_frontend_v2/widgets/not_used_widgets/custom_search_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../constants/style.dart';
import '../../../../models/document/document_model.dart';
import '../../../../widgets/custom_text_field_double.dart';

class DocumentItemsDataTable extends ConsumerStatefulWidget {
  const DocumentItemsDataTable(
      {super.key,
      required this.data,
      required this.onUpdate,
      this.readOnly,
      this.noPrice});
  final List<DocumentItem>? data;

  final bool? readOnly;
  final void Function(List<DocumentItem>) onUpdate;
  final bool? noPrice;

  @override
  ConsumerState<DocumentItemsDataTable> createState() =>
      _DocumentItemsDataTableState();
}

class _DocumentItemsDataTableState
    extends ConsumerState<DocumentItemsDataTable> {
  void updateDocumentItemAmount(int index) {
    setState(() {
      widget.data![index].amountNet =
          widget.data![index].quantity * widget.data![index].price!;

      widget.data![index].amountVat = widget.data![index].amountNet! *
          widget.data![index].item.vat.percent /
          100;

      widget.data![index].amountGross =
          widget.data![index].amountNet! + widget.data![index].amountVat!;
    });
  }

  void updateDocumentItemPrice(int index) {
    setState(() {
      widget.data![index].amountNet = (widget.data![index].amountGross! * 100) /
          (100 + widget.data![index].item.vat.percent);

      widget.data![index].amountVat =
          widget.data![index].amountGross! - widget.data![index].amountNet!;

      widget.data![index].price =
          widget.data![index].amountNet! / widget.data![index].quantity;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: CustomStyle.customContainerDecoration(),
      child:
          CustomDataTable(columns: getColumns(), rows: getRows(widget.data!)),
    );
  }

  List<DataColumn2> getColumns() {
    List<DataColumn2> _columns = [
      // const DataColumn2(
      //   label: Text('Cod'),
      //   size: ColumnSize.S,
      // ),
      const DataColumn2(
        label: Text('Denumire'),
        size: ColumnSize.L,
      ),
      const DataColumn2(
        label: Text('Cantitate'),
        size: ColumnSize.S,
      ),
      const DataColumn2(
        label: Text('UM'),
        size: ColumnSize.S,
      ),
      if (widget.noPrice != true) ...[
        DataColumn2(
          label: Text('Pret'),
          size: ColumnSize.S,
        ),
        const DataColumn2(
          label: Text('VAT'),
          size: ColumnSize.S,
        ),
        const DataColumn2(
          label: Text('Valoare Neta'),
          size: ColumnSize.M,
        ),
        const DataColumn2(
          label: Text('Valoare TVA'),
          size: ColumnSize.M,
        ),
        const DataColumn2(
          label: Text('Valoare Total'),
          size: ColumnSize.M,
        ),
      ],
      const DataColumn2(
        label: Text('Sterge'),
        fixedWidth: 100,
      ),
    ];
    // Hide Actions column if readOnly==true
    if (widget.readOnly == true) {
      _columns.last = const DataColumn2(
        label: Text('Actions'),
        fixedWidth: 0,
      );
    }
    return _columns;
  }

  List<DataRow2> getRows(List<DocumentItem> data) {
    List<DataRow2> rows = data.asMap().entries.map((row) {
      int index = row.key;

      List<DataCell> cells = [
        // DataCell(Text(row.value.code ?? '')),
        DataCell(Text(row.value.item.name)),
        DataCell(
          CustomTextFieldFloat(
            initialValue: row.value.quantity,
            onValueChanged: (double value) {
              data[index].quantity = value;
              updateDocumentItemAmount(index);
              widget.onUpdate(data);
            },
            readonly: widget.readOnly,
          ),
        ),
        DataCell(Text(row.value.item.um.name)),

        if (widget.noPrice != true) ...[
          DataCell(
            CustomTextFieldFloat(
              initialValue: row.value.price != null ? row.value.price! : 0.00,
              onValueChanged: (double value) {
                data[index].price = value;
                updateDocumentItemAmount(index);
                widget.onUpdate(data);
              },
              readonly: widget.readOnly,
            ),
          ),
          DataCell(Text(row.value.item.vat.name)),
          DataCell(
            CustomTextFieldFloat(
              initialValue:
                  row.value.amountNet != null ? row.value.amountNet! : 0.00,
              onValueChanged: (double value) {
                data[index].amountNet = value;
                widget.onUpdate(data);
              },
              readonly: true,
            ),
          ),
          DataCell(
            CustomTextFieldFloat(
              initialValue:
                  row.value.amountVat != null ? row.value.amountVat! : 0.00,
              onValueChanged: (double value) {
                data[index].amountVat = value;
                widget.onUpdate(data);
              },
              readonly: true,
            ),
          ),
          DataCell(
            CustomTextFieldFloat(
              initialValue:
                  row.value.amountGross != null ? row.value.amountGross! : 0.00,
              onValueChanged: (double value) {
                data[index].amountGross = value;
                updateDocumentItemPrice(index);
                widget.onUpdate(data);
              },
              readonly: widget.readOnly,
            ),
          ),
        ],

        DataCell(
          Visibility(
            visible: widget.readOnly != true,
            child: IconButton(
              hoverColor: CustomColor.lightest,
              splashRadius: 22,
              icon: const Icon(Icons.delete_outlined, color: Colors.red),
              onPressed: () {
                setState(() {
                  widget.data!.remove(data[index]);
                  widget.onUpdate(data);
                });
              },
            ),
          ),
        ),
      ];

      return DataRow2(
        cells: cells,
      );
    }).toList();

    // // Define the empty cells for the empty row
    // List<DataCell> emptyCells = List.generate(getColumns().length, (index) {
    //   if (index == 0) {
    //     // Assuming 'Denumire' is at index 1
    //     // Return a DataCell containing your custom widget for 'Denumire' column
    //     return DataCell(DocumentSearchDropDown(
    //       // Ensure this key is unique or managed properly if it's reused
    //       //initialValue: _document.partner,

    //       onValueChanged: (value) {
    //         //
    //       },
    //       provider: partnerProvider,
    //     ));
    //   } else {
    //     // Return an empty DataCell for other columns
    //     return DataCell(Text(''));
    //   }
    // });

    // // Create the empty row using the defined empty cells
    // DataRow2 emptyRow = DataRow2(cells: emptyCells);

    // // Append the empty row to your rows list
    // rows.add(emptyRow);

    return rows;
  }
}
