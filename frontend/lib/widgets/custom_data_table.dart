import 'package:data_table_2/data_table_2.dart';
import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/utils/util_functions.dart';
import 'package:erp_frontend_v2/widgets/custom_checkbox.dart';
import 'package:erp_frontend_v2/widgets/custom_pagination.dart';

import 'package:flutter/material.dart';

class CustomDataTable extends StatefulWidget {
  final List<DataColumn2> columns;
  final List<DataRow2> rows;
  final bool? showTotals;
  final bool? showPagination;
  final bool? showCheckBoxColumn;
  final int? keyColumnIndex;
  final List<int>? hiddenColumnIndices;
  final void Function(List<String>)? onRowSelect;
  final List<int>? totalsConfig;

  const CustomDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.keyColumnIndex,
    this.hiddenColumnIndices,
    this.showTotals,
    this.totalsConfig,
    this.showPagination = false,
    this.showCheckBoxColumn = false,
    this.onRowSelect,
  });

  @override
  State<CustomDataTable> createState() => CustomDataTableState();
}

class CustomDataTableState extends State<CustomDataTable> {
  int _page = 0;
  final int _itemPerPage = 10;
  List<DataRow2> rowsToShow = [];
  List<String> selectedRowIds = [];
  bool _selectAll = false;
  List<DataColumn2> columns = [];
  List<DataRow2> rows = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CustomDataTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initializeOrUpdateSelectedRows();
  }

  void _initializeOrUpdateSelectedRows() {
    // Ensure both keyColumnIndex and checkboxes are enabled
    if (widget.keyColumnIndex != null && widget.showCheckBoxColumn == true) {
      setState(() {
        final oldSelectedRowIds =
            List.of(selectedRowIds); // Copy existing values
        // Preserve old selections if they still exist in new rows
        selectedRowIds = oldSelectedRowIds.where((id) {
          return widget.rows.any((row) {
            final cellWidget = row.cells[widget.keyColumnIndex!].child;
            if (cellWidget is Text) {
              return cellWidget.data == id;
            }
            return false;
          });
        }).toList();

        // Update the _selectAll state
        _selectAll = selectedRowIds.length == widget.rows.length;
      });
    }
  }

  void _toggleSelectAll(bool? newValue) {
    // Ensure both keyColumnIndex and checkboxes are enabled
    if (widget.keyColumnIndex != null && widget.showCheckBoxColumn == true) {
      setState(() {
        _selectAll = newValue!;
        if (_selectAll) {
          selectedRowIds = widget.rows.map((row) {
            final cellWidget = row.cells[widget.keyColumnIndex!].child;
            if (cellWidget is Text) {
              return cellWidget.data ?? '';
            }
            return '';
          }).toList();
        } else {
          selectedRowIds.clear();
        }

        if (widget.onRowSelect != null) {
          widget.onRowSelect!(selectedRowIds);
        }
      });
    }
  }

  void selectOne(bool newValue, String id) {
    // Ensure both keyColumnIndex and checkboxes are enabled
    if (widget.keyColumnIndex != null && widget.showCheckBoxColumn == true) {
      setState(() {
        if (newValue) {
          selectedRowIds.add(id);
        } else {
          selectedRowIds.remove(id);
        }

        _selectAll = selectedRowIds.length == widget.rows.length;

        if (widget.onRowSelect != null) {
          widget.onRowSelect!(selectedRowIds);
        }
      });
    }
  }

  // Method to deselect all rows
  void deselectAllRows() {
    if (widget.keyColumnIndex != null && widget.showCheckBoxColumn == true) {
      setState(() {
        _selectAll = false;
        selectedRowIds.clear();

        if (widget.onRowSelect != null) {
          widget.onRowSelect!(selectedRowIds);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const dataRowHeight = 57.0;
    const headingRowHeight = 57.0;

    // Step 1: Filter the columns to remove hidden ones
    columns = widget.columns
        .asMap()
        .entries
        .where((entry) =>
            !(widget.hiddenColumnIndices?.contains(entry.key) ?? false))
        .map((entry) => entry.value)
        .toList();

    // Step 2: Only add checkbox column if both conditions are met
    if (widget.showCheckBoxColumn == true && widget.keyColumnIndex != null) {
      columns.insert(
        0,
        DataColumn2(
          label: Checkbox(
            value: _selectAll,
            onChanged: _toggleSelectAll,
          ),
          fixedWidth: 50,
        ),
      );
    }

    // Step 3: Filter the rows to remove the cells for the hidden columns
    rows = widget.rows.map((row) {
      List<DataCell> visibleCells = row.cells
          .asMap()
          .entries
          .where((entry) =>
              !(widget.hiddenColumnIndices?.contains(entry.key) ?? false))
          .map((entry) => entry.value)
          .toList();

      // Step 4: Add checkbox to each row if both conditions are met
      if (widget.showCheckBoxColumn == true && widget.keyColumnIndex != null) {
        final keyColumnValue =
            (row.cells[widget.keyColumnIndex!].child as Text).data;
        visibleCells.insert(
          0,
          DataCell(
            Checkbox(
              value: selectedRowIds.contains(keyColumnValue),
              onChanged: (bool? value) {
                selectOne(value!, keyColumnValue!);
              },
            ),
          ),
        );
      }

      return DataRow2(cells: visibleCells);
    }).toList();

    // Step 5: Calculate the rows to show based on the current page
    rowsToShow = rows
        .skip(_page * _itemPerPage)
        .take(_itemPerPage)
        .toList(growable: false);

    void _changePage(int index) {
      setState(() {
        _page = index;
        rowsToShow = rows
            .skip(_page * _itemPerPage)
            .take(_itemPerPage)
            .toList(growable: false);
      });
    }

    return Container(
      height:
          ((widget.showPagination == true ? rowsToShow.length : rows.length) *
                  dataRowHeight) +
              headingRowHeight +
              (widget.showPagination == true ? 60 : 0),
      child: Column(
        children: [
          Flexible(
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
              rows: widget.showPagination == true
                  ? rowsToShow
                  : rows, // Filtered rows
            ),
          ),
          if (widget.showPagination == true)
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: CustomColor.greenGray.withOpacity(0.1),
                  ),
                ),
              ),
              child: CustomPagination(
                itemCount: widget.rows.length,
                rowsCount: rowsToShow.length,
                asyncOnPressed: (int index) async {
                  _changePage(index);
                },
              ),
            ),
        ],
      ),
    );
  }
}
