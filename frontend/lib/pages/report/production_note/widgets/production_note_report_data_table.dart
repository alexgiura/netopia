import 'package:erp_frontend_v2/models/report/production_note_report_model.dart';
import 'package:erp_frontend_v2/widgets/custom_data_table.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';
import '../../../../constants/style.dart';

class ProductionNoteReportPageDataTable extends ConsumerStatefulWidget {
  const ProductionNoteReportPageDataTable({super.key, required this.data});
  final List<ProductionNoteReport> data;

  @override
  ConsumerState<ProductionNoteReportPageDataTable> createState() =>
      _ProductionNoteReportPageDataTableState();
}

class _ProductionNoteReportPageDataTableState
    extends ConsumerState<ProductionNoteReportPageDataTable> {
  // bool _isLoading = false;
  // List<ProductionNoteReport> _docs = [];
  // ReportFilter _reportFilter = ReportFilter.empty();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: CustomStyle.customContainerDecoration(),
            child: Column(
              children: [
                Expanded(
                  child: CustomDataTable(
                    columns: _columns,
                    rows: getRows(widget.data),
                    showTotals: true,
                    totalsConfig: [3, 4, 5, 6, 7, 8, 9],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<DataRow2> getRows(List<ProductionNoteReport> data) {
    return data.asMap().entries.map((row) {
      return DataRow2(
        cells: [
          DataCell(Text(row.value.date)),
          DataCell(Text(row.value.partnerName)),
          DataCell(Text(row.value.itemName)),
          DataCell(Text(row.value.itemQuantity.toStringAsFixed(2))),
          DataCell(Text(row.value.rawMaterial[0].toStringAsFixed(3))),
          DataCell(Text(row.value.rawMaterial[1].toStringAsFixed(3))),
          DataCell(Text(row.value.rawMaterial[2].toStringAsFixed(3))),
          DataCell(Text(row.value.rawMaterial[3].toStringAsFixed(3))),
          DataCell(Text(row.value.rawMaterial[4].toStringAsFixed(3))),
          DataCell(Text(row.value.rawMaterial[5].toStringAsFixed(3))),
        ],
      );
    }).toList();
  }
}

List<DataColumn2> _columns = [
  const DataColumn2(
    label: Text('Data'),
    size: ColumnSize.S,
  ),
  const DataColumn2(
    label: Text('Client'),
    size: ColumnSize.L,
  ),
  const DataColumn2(
    label: Text('Tip beton'),
    size: ColumnSize.S,
  ),
  const DataColumn2(
    label: Text('Cantitate'),
    size: ColumnSize.S,
    numeric: true,
  ),
  const DataColumn2(
    label: Text('0-4\n(tone)'),
    size: ColumnSize.S,
    numeric: true,
  ),
  const DataColumn2(
    label: Text('4-8\n(tone)'),
    size: ColumnSize.S,
    numeric: true,
  ),
  const DataColumn2(
    label: Text('8-16\n(tone)'),
    size: ColumnSize.S,
    numeric: true,
  ),
  const DataColumn2(
    label: Text('16-32\n(tone)'),
    size: ColumnSize.S,
    numeric: true,
  ),
  const DataColumn2(
    label: Text('Ciment'),
    size: ColumnSize.S,
    numeric: true,
  ),
  const DataColumn2(
    label: Text('Aditiv'),
    size: ColumnSize.S,
    numeric: true,
  ),
];
