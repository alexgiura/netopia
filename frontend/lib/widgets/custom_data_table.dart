import 'package:data_table_2/data_table_2.dart';
import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/utils/util_functions.dart';
import 'package:flutter/material.dart';

class CustomDataTable extends StatelessWidget {
  final List<DataColumn2> columns;
  final List<DataRow2> rows;
  final bool? showTotals;
  final List<int>? totalsConfig;
  const CustomDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.showTotals,
    this.totalsConfig,
  });

  @override
  Widget build(BuildContext context) {
    const dataRowHeight = 56.0;
    const headingRowHeight = 56.0;
    return Container(
      height: rows.length * dataRowHeight + headingRowHeight,
      child: DataTable2(
          isHorizontalScrollBarVisible: false,
          isVerticalScrollBarVisible: false,
          showCheckboxColumn: false,
          dividerThickness: 0.5,
          showBottomBorder: false,
          dataRowHeight: dataRowHeight,
          headingRowHeight: headingRowHeight,
          horizontalMargin: 16,
          columnSpacing: 0,
          columns: columns,
          rows: rows),
    );
  }

  // Widget _buildTotalsRow(List<double?> totals) {
  //   // Suppose M is base and has a factor of 2
  //   const int baseFlex = 2;
  //   const double smRatio = 0.67; // Raport S/M
  //   const double lmRatio = 1.2; // Raport L/M

  //   return Container(
  //     height: 48,
  //     decoration: const BoxDecoration(
  //       border: Border(
  //         top: BorderSide(
  //           color: CustomColor.light,
  //           width: 0.5,
  //         ),
  //       ),
  //     ),
  //     child: Row(
  //       children: List<Widget>.generate(columns.length, (index) {
  //         int flexFactor;
  //         switch (columns[index].size) {
  //           case ColumnSize.S:
  //             flexFactor = (baseFlex * smRatio).round();
  //             break;
  //           case ColumnSize.M:
  //             flexFactor = baseFlex;
  //             break;
  //           case ColumnSize.L:
  //             flexFactor = (baseFlex * lmRatio).round();
  //             break;
  //           default:
  //             flexFactor = baseFlex; // Valoare default pentru siguranță
  //         }

  //         if (totals[index] != null) {
  //           return Expanded(
  //             flex: flexFactor,
  //             child: Container(
  //               alignment: Alignment.centerRight,
  //               padding: const EdgeInsets.symmetric(horizontal: 16),
  //               child: Text(
  //                 formatNumber(totals[index]!),
  //                 style: CustomStyle.bodyTextBold,
  //               ),
  //             ),
  //           );
  //         } else {
  //           // Spatiu gol pentru coloanele fara total
  //           return Expanded(
  //             flex: flexFactor,
  //             child: Container(),
  //           );
  //         }
  //       }),
  //     ),
  //   );
  // }

  // List<double?> calculateTotals(List<DataColumn2> columns, List<DataRow2> rows,
  //     List<int> columnsToTotal) {
  //   List<double?> totals = List.filled(columns.length, null, growable: false);

  //   for (DataRow2 row in rows) {
  //     for (var columnIndex in columnsToTotal) {
  //       final cellWidget = row.cells[columnIndex].child;
  //       String? cellValue = cellWidget is Text ? cellWidget.data : null;
  //       double value = double.tryParse(cellValue ?? "0") ?? 0.0;
  //       totals[columnIndex] = (totals[columnIndex] ?? 0.0) + value;
  //     }
  //   }

  //   return totals;
  // }
}
