import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/models/report/item_stock_report_model.dart';
import 'package:erp_frontend_v2/services/report.dart';
import 'package:erp_frontend_v2/widgets/custom_data_table.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';

class ItemStockReportPageDataTable extends StatefulWidget {
  const ItemStockReportPageDataTable(
      {super.key, required this.data, this.title});
  final List<ItemStockReport>? data;
  final String? title;

  @override
  State<ItemStockReportPageDataTable> createState() =>
      _ItemStockReportPageDataTableState();
}

class _ItemStockReportPageDataTableState
    extends State<ItemStockReportPageDataTable> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.all(16),
      // margin: const EdgeInsets.only(bottom: 30),
      decoration: CustomStyle.customContainerDecoration(),
      child: CustomDataTable(
        columns: _columns,
        rows: getRows(widget.data!),
      ),
    );
  }

  List<DataRow2> getRows(List<ItemStockReport> data) {
    return data.asMap().entries.map((row) {
      return DataRow2(
        cells: [
          // DataCell(Text(row.value.itemCode!)),
          DataCell(Text(row.value.itemName)),

          DataCell(Align(
              alignment: Alignment.centerRight,
              child: Text(row.value.itemQuantity.toStringAsFixed(2)))),
          DataCell(Align(
              alignment: Alignment.centerRight,
              child: Text(row.value.itemUm!))),
        ],
      );
    }).toList();
  }
}

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
    label: Align(alignment: Alignment.centerRight, child: Text('Cantitate')),
    size: ColumnSize.S,
  ),
  const DataColumn2(
    label: Align(alignment: Alignment.centerRight, child: Text('UM')),
    size: ColumnSize.S,
  ),
];
