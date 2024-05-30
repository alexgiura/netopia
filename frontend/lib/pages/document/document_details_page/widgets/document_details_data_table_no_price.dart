import 'package:erp_frontend_v2/models/partner/partner_model.dart';
import 'package:erp_frontend_v2/pages/document/document_generate_popup/document_generate_popup.dart';
import 'package:erp_frontend_v2/providers/document_transaction_provider.dart';
import 'package:erp_frontend_v2/widgets/custom_data_table.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../constants/style.dart';
import '../../../../models/document/document_model.dart';
import '../../../../widgets/custom_text_field_double.dart';
import '../../document_add_item/document_add_item_popup.dart';

class DocumentItemsNoPriceDataTable extends ConsumerStatefulWidget {
  const DocumentItemsNoPriceDataTable(
      {super.key,
      required this.data,
      required this.documentTypeId,
      required this.onUpdate,
      required this.partner,
      required this.date,
      this.readOnly,
      this.generateButton});
  final List<DocumentItem>? data;
  final bool? readOnly;
  final int documentTypeId;
  final void Function(List<DocumentItem>) onUpdate;
  final Partner partner;
  final String date;
  final Widget? generateButton;

  @override
  ConsumerState<DocumentItemsNoPriceDataTable> createState() =>
      _DocumentItemsNoPriceDataTableState();
}

class _DocumentItemsNoPriceDataTableState
    extends ConsumerState<DocumentItemsNoPriceDataTable> {
  @override
  Widget build(BuildContext context) {
    // Hide Actions column if readOnly==true
    if (widget.readOnly == true) {
      _columns.last = const DataColumn2(
        label: Text('Actions'),
        fixedWidth: 0,
      );
    }

    return Container(
      decoration: CustomStyle.customContainerDecoration,
      child: CustomDataTable(columns: _columns, rows: getRows(widget.data!)),
    );
  }

  List<DataRow2> getRows(List<DocumentItem> data) {
    return data.asMap().entries.map((row) {
      int index = row.key;

      List<DataCell> cells = [
        // DataCell(Text(row.value.code ?? '')),
        DataCell(Text(row.value.item.name)),
        DataCell(
          CustomTextFieldFloat(
            initialValue: row.value.quantity,
            onValueChanged: (double value) {
              data[index].quantity = value;
              widget.onUpdate(data);
            },
            readonly: widget.readOnly,
          ),
        ),
        DataCell(Text(row.value.item.um.name)),
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
  }

  //

  final List<DataColumn2> _columns = [
    // const DataColumn2(
    //   label: Text('Cod'),
    //   size: ColumnSize.L,
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
    const DataColumn2(
      label: Text('Sterge'),
      fixedWidth: 100,
    ),
  ];
}
