import 'package:data_table_2/data_table_2.dart';
import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/models/report/item_stock_report_model.dart';
import 'package:erp_frontend_v2/services/report.dart';
import 'package:erp_frontend_v2/widgets/custom_data_table.dart';
import 'package:flutter/material.dart';

class ItemStockDataTable extends StatefulWidget {
  const ItemStockDataTable({super.key, this.title});
  // final List<ItemStockReport>? data;
  final String? title;

  @override
  State<ItemStockDataTable> createState() => _ItemStockDataTableState();
}

class _ItemStockDataTableState extends State<ItemStockDataTable> {
  bool _isLoading = false;
  List<ItemStockReport> _docs = [];

  //Filters
  DateTime _date = DateTime.now();
  List<int>? _inventoryList;
  List<int>? _itemCategoryList;
  List<String>? _itemList;

  void _handleFilterChange(
    DateTime date,
    List<int>? inventoryList,
    List<int>? itemCategoryList,
    List<String>? itemList,
  ) {
    setState(() {
      _date = date;
      _inventoryList = inventoryList;
      _itemCategoryList = itemCategoryList;
      _itemList = itemList;
    });
  }

  Future<void> _fetchDocuments() async {
    try {
      final reportService = ReportService();
      final docs = await reportService.getItemStockReport(
          date: _date,
          inventoryList: _inventoryList,
          itemCategoryList: _itemCategoryList,
          itemList: _itemList);

      setState(() {
        _docs = docs;
      });
    } catch (error) {}
  }

  Future<void> _initializeData() async {
    setState(() {
      _isLoading = true;
    });

    _date =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    await _fetchDocuments();
    //await _generatePdf();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 30),
      decoration: CustomStyle.customContainerDecoration(),
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 16),
              if (widget.title != null)
                Column(
                  children: [
                    Text(
                      widget.title!,
                      style: CustomStyle.subtitleText,
                    ),
                    const SizedBox(height: 16),
                  ],
                )
            ],
          ),
          Expanded(
            child: CustomDataTable(
              columns: _columns,
              rows: getRows(_docs),
            ),
          )
        ],
      ),
    );
  }

  List<DataRow2> getRows(List<ItemStockReport> data) {
    return data.asMap().entries.map((row) {
      return DataRow2(
        cells: [
          DataCell(Text(row.value.itemCode!)),
          DataCell(Text(row.value.itemName)),
          DataCell(Text(row.value.itemUm!)),
          DataCell(Text(row.value.itemQuantity.toString())),
        ],
      );
    }).toList();
  }
}

List<DataColumn2> _columns = [
  const DataColumn2(
    label: Text('Cod'),
    size: ColumnSize.S,
  ),
  const DataColumn2(
    label: Text('Denumire'),
    size: ColumnSize.L,
  ),
  const DataColumn2(
    label: Text('UM'),
    size: ColumnSize.S,
  ),
  const DataColumn2(
    label: Text('Cantitate'),
    size: ColumnSize.S,
  ),
];
