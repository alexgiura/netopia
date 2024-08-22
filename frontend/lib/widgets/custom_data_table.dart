import 'package:data_table_2/data_table_2.dart';
import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/utils/util_functions.dart';
import 'package:erp_frontend_v2/widgets/custom_pagination.dart';
import 'package:flutter/material.dart';

class CustomDataTable extends StatefulWidget {
  final List<DataColumn2> columns;
  final List<DataRow2> rows;
  final bool? showTotals;

  /// It's default value is true, but it can be set to false if the pagination is not needed
  final bool showPagination;

  /// The function that will be called when a pagination button is pressed
  final List<int>? totalsConfig;
  const CustomDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.showTotals,
    this.totalsConfig,
    this.showPagination = true,
  });

  @override
  State<CustomDataTable> createState() => _CustomDataTableState();
}

class _CustomDataTableState extends State<CustomDataTable> {
  int _page = 0;
  final int _itemPerPage = 10;
  List<DataRow2> rowsToShow = [];

  @override
  Widget build(BuildContext context) {
    const dataRowHeight = 57.0;
    const headingRowHeight = 57.0;

    // Calculate the rows to show based on the current page
    rowsToShow = widget.rows
        .skip(_page * _itemPerPage)
        .take(_itemPerPage)
        .toList(growable: false);

    void _changePage(int index) {
      setState(() {
        _page = index; // Update the _page variable
        rowsToShow = widget.rows
            .skip(_page * _itemPerPage)
            .take(_itemPerPage)
            .toList(growable: false);
      });
    }

    if (mounted) _page = 0;

    return Container(
      height: rowsToShow.length * dataRowHeight + headingRowHeight + 60,
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
                columns: widget.columns,
                rows: rowsToShow),
          ),
          if (widget.showPagination)
            Container(
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(
                          color: CustomColor.greenGray.withOpacity(0.1)))),
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
