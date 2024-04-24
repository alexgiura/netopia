// import 'package:data_table_2/data_table_2.dart';
// import 'package:erp_frontend_v2/constants/style.dart';
// import 'package:erp_frontend_v2/utils/util_functions.dart';
// import 'package:erp_frontend_v2/widgets/custom_checkbox.dart';
// import 'package:flutter/material.dart';

// class CustomDataTable extends StatefulWidget {
//   final List<DataColumn2> columns;
//   final List<DataRow2> rows;
//   final bool? showTotals;
//   final List<int>? totalsConfig;
//   final bool showCheckbox;
//   final Function(List<int>)? onSelectRows;
//   const CustomDataTable(
//       {super.key,
//       required this.columns,
//       required this.rows,
//       this.showTotals,
//       this.totalsConfig,
//       this.showCheckbox = false,
//       this.onSelectRows});

//   @override
//   State<CustomDataTable> createState() => _CustomDataTableState();
// }

// class _CustomDataTableState extends State<CustomDataTable> {
//   late List<bool> checkboxValues;
//   bool _selectAll = false;
//   Set<int> selectedIndices = {};

//   @override
//   void initState() {
//     super.initState();
//   }

//   void selectOne(bool newValue, int index) {
//     setState(() {
//       checkboxValues[index] = newValue;
//       if (newValue) {
//         selectedIndices.add(index); // Add index if checkbox is checked
//       } else {
//         selectedIndices.remove(index); // Remove index if checkbox is unchecked
//       }
//       _selectAll = selectedIndices.length ==
//           widget.rows.length; // Update select all checkbox
//       _updateSelectedRows();
//     });
//   }

//   void _toggleSelectAll(bool newValue) {
//     setState(() {
//       _selectAll = newValue;
//       checkboxValues = List.filled(widget.rows.length, _selectAll);
//       if (_selectAll) {
//         selectedIndices = Set.from(Iterable.generate(widget.rows.length));
//       } else {
//         selectedIndices.clear();
//       }
//       _updateSelectedRows();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Initialize checkboxValues
//     checkboxValues = List.generate(widget.rows.length, (index) => false);
//     List<DataColumn2> modifiedColumns = widget.columns;

//     if (widget.showCheckbox) {
//       modifiedColumns = [
//         DataColumn2(
//           label: CustomCheckbox(
//             value: _selectAll,
//             onChanged: _toggleSelectAll,
//           ),
//           fixedWidth: 50,
//         ),
//         ...widget.columns,
//       ];
//     }

//     return Column(
//       children: [
//         Expanded(
//           child: DataTable2(
//               dataRowColor: MaterialStateProperty.resolveWith<Color?>(
//                   (Set<MaterialState> states) {
//                 if (states.contains(MaterialState.hovered)) {
//                   return CustomColor.active.withOpacity(0.1);
//                 }

//                 return null;
//               }),
//               // headingRowColor: MaterialStateProperty.all(CustomColor.lightest),
//               dataTextStyle: CustomStyle.bodyText,
//               headingTextStyle: CustomStyle.bodyTextBold,
//               showCheckboxColumn: false,
//               dividerThickness: 0.5,
//               showBottomBorder: true,
//               dataRowHeight: 48,
//               headingRowHeight: 48,
//               horizontalMargin: 16,
//               columnSpacing: 0,
//               columns: modifiedColumns,
//               rows: _buildDataRows()),
//         ),
//         if (widget.showTotals == true &&
//             widget.totalsConfig != null &&
//             widget.totalsConfig!.isNotEmpty)
//           _buildTotalsRow(calculateTotals(
//               modifiedColumns, widget.rows, widget.totalsConfig!)),
//       ],
//     );
//   }

//   List<DataRow> _buildDataRows() {
//     return List.generate(widget.rows.length, (index) {
//       List<DataCell> cells = [];

//       if (widget.showCheckbox) {
//         cells.add(DataCell(
//           Align(
//             alignment: Alignment.centerLeft,
//             child: CustomCheckbox(
//               value: checkboxValues[index],
//               onChanged: (newValue) {
//                 selectOne(newValue, index);
//               },
//             ),
//           ),
//         ));
//       }

//       // Convert DataRow2 to List<DataCell>
//       cells.addAll(widget.rows[index].cells.map((cell) => cell as DataCell));

//       return DataRow(cells: cells);
//     });
//   }

//   void _updateSelectedRows() {
//     if (widget.onSelectRows != null) {
//       widget.onSelectRows!(
//           selectedIndices.toList()); // Convert set to list and pass to callback
//     }
//   }

//   Widget _buildTotalsRow(List<double?> totals) {
//     // Suppose M is base and has a factor of 2
//     const int baseFlex = 2;
//     const double smRatio = 0.67; // Raport S/M
//     const double lmRatio = 1.2; // Raport L/M

//     return Container(
//       height: 48,
//       decoration: const BoxDecoration(
//         border: Border(
//           top: BorderSide(
//             color: CustomColor.light,
//             width: 0.5,
//           ),
//         ),
//       ),
//       child: Row(
//         children: List<Widget>.generate(widget.columns.length, (index) {
//           int flexFactor;
//           switch (widget.columns[index].size) {
//             case ColumnSize.S:
//               flexFactor = (baseFlex * smRatio).round();
//               break;
//             case ColumnSize.M:
//               flexFactor = baseFlex;
//               break;
//             case ColumnSize.L:
//               flexFactor = (baseFlex * lmRatio).round();
//               break;
//             default:
//               flexFactor = baseFlex; // Valoare default pentru siguranță
//           }

//           if (totals[index] != null) {
//             return Expanded(
//               flex: flexFactor,
//               child: Container(
//                 alignment: Alignment.centerRight,
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Text(
//                   formatNumber(totals[index]!),
//                   style: CustomStyle.bodyTextBold,
//                 ),
//               ),
//             );
//           } else {
//             // Spatiu gol pentru coloanele fara total
//             return Expanded(
//               flex: flexFactor,
//               child: Container(),
//             );
//           }
//         }),
//       ),
//     );
//   }

//   List<double?> calculateTotals(List<DataColumn2> columns, List<DataRow2> rows,
//       List<int> columnsToTotal) {
//     List<double?> totals = List.filled(columns.length, null, growable: false);

//     for (DataRow2 row in rows) {
//       for (var columnIndex in columnsToTotal) {
//         final cellWidget = row.cells[columnIndex].child;
//         String? cellValue = cellWidget is Text ? cellWidget.data : null;
//         double value = double.tryParse(cellValue ?? "0") ?? 0.0;
//         totals[columnIndex] = (totals[columnIndex] ?? 0.0) + value;
//       }
//     }

//     return totals;
//   }
// }

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
    return Column(
      children: [
        Expanded(
          child: DataTable2(
              dataRowColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.hovered)) {
                  return CustomColor.active.withOpacity(0.1);
                }

                return null;
              }),
              // headingRowColor: MaterialStateProperty.all(CustomColor.lightest),
              dataTextStyle: CustomStyle.bodyText,
              headingTextStyle: CustomStyle.bodyText,
              showCheckboxColumn: false,
              dividerThickness: 0.5,
              showBottomBorder: true,
              dataRowHeight: 48,
              headingRowHeight: 48,
              horizontalMargin: 16,
              columnSpacing: 0,
              columns: columns,
              rows: rows),
        ),
        if (showTotals == true &&
            totalsConfig != null &&
            totalsConfig!.isNotEmpty)
          _buildTotalsRow(calculateTotals(columns, rows, totalsConfig!)),
      ],
    );
  }

  Widget _buildTotalsRow(List<double?> totals) {
    // Suppose M is base and has a factor of 2
    const int baseFlex = 2;
    const double smRatio = 0.67; // Raport S/M
    const double lmRatio = 1.2; // Raport L/M

    return Container(
      height: 48,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: CustomColor.light,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: List<Widget>.generate(columns.length, (index) {
          int flexFactor;
          switch (columns[index].size) {
            case ColumnSize.S:
              flexFactor = (baseFlex * smRatio).round();
              break;
            case ColumnSize.M:
              flexFactor = baseFlex;
              break;
            case ColumnSize.L:
              flexFactor = (baseFlex * lmRatio).round();
              break;
            default:
              flexFactor = baseFlex; // Valoare default pentru siguranță
          }

          if (totals[index] != null) {
            return Expanded(
              flex: flexFactor,
              child: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  formatNumber(totals[index]!),
                  style: CustomStyle.bodyTextBold,
                ),
              ),
            );
          } else {
            // Spatiu gol pentru coloanele fara total
            return Expanded(
              flex: flexFactor,
              child: Container(),
            );
          }
        }),
      ),
    );
  }

  List<double?> calculateTotals(List<DataColumn2> columns, List<DataRow2> rows,
      List<int> columnsToTotal) {
    List<double?> totals = List.filled(columns.length, null, growable: false);

    for (DataRow2 row in rows) {
      for (var columnIndex in columnsToTotal) {
        final cellWidget = row.cells[columnIndex].child;
        String? cellValue = cellWidget is Text ? cellWidget.data : null;
        double value = double.tryParse(cellValue ?? "0") ?? 0.0;
        totals[columnIndex] = (totals[columnIndex] ?? 0.0) + value;
      }
    }

    return totals;
  }
}
