import 'package:erp_frontend_v2/models/document/document_generate_model.dart';
import 'package:erp_frontend_v2/widgets/custom_data_table.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../constants/style.dart';
import '../../../../widgets/custom_text_field_double.dart';

class TransactionAvailableItemsDataTable extends ConsumerStatefulWidget {
  const TransactionAvailableItemsDataTable({
    super.key,
    required this.data,
  });
  final List<DocumentGenerate> data;

  @override
  ConsumerState<TransactionAvailableItemsDataTable> createState() =>
      _TransactionAvailableItemsDataTableState();
}

class _TransactionAvailableItemsDataTableState
    extends ConsumerState<TransactionAvailableItemsDataTable> {
  // List<DocumentGenerate> _selectedItems = [];

  @override
  void initState() {
    super.initState();
    // Initialize checkboxValues
    // checkboxValues = List.generate(widget.data.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: CustomStyle.customContainerDecoration,
        child: CustomDataTable(columns: _columns, rows: getRows(widget.data)));
  }

  List<DataRow2> getRows(List<DocumentGenerate> data) {
    //
    return data.asMap().entries.map((row) {
      List<DataCell> cells = [
        DataCell(Text(row.value.number)),
        DataCell(Text(row.value.date)),
        DataCell(Text(row.value.documentItem.name)),
        DataCell(Text(row.value.documentItem.quantity.toString())),
        DataCell(Text(row.value.documentItem.um.name)),
      ];

      return DataRow2(
        cells: cells,
      );
    }).toList();
  }

  //

  final List<DataColumn2> _columns = [
    const DataColumn2(
      label: Text('Numar document'),
      size: ColumnSize.M,
    ),
    const DataColumn2(
      label: Text('Data document'),
      size: ColumnSize.M,
    ),
    const DataColumn2(
      label: Text('Denumire Produs'),
      size: ColumnSize.M,
    ),
    const DataColumn2(
      label: Text('Cantitate Rămasă'),
      size: ColumnSize.M,
    ),
    const DataColumn2(
      label: Text('UM'),
      size: ColumnSize.M,
    ),
  ];
}
