import 'dart:typed_data';
import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/utils/responsiveness.dart';
import 'package:erp_frontend_v2/models/report/item_stock_report_model.dart';
import 'package:erp_frontend_v2/pages/report/item_stock/widgets/item_stock_report_data_table.dart';
import 'package:erp_frontend_v2/pages/report/item_stock/widgets/pdf_item_stock_report.dart';
import 'package:erp_frontend_v2/providers/item_provider.dart';
import 'package:erp_frontend_v2/services/report.dart';
import 'package:erp_frontend_v2/widgets/filters/date_interval_picker/date_picker_widget.dart';
import 'package:erp_frontend_v2/widgets/filters/drop_down_filter/drop_down_filter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:html' as html;

class ItemStockReportPage extends StatefulWidget {
  const ItemStockReportPage({super.key});

  @override
  State<ItemStockReportPage> createState() => _ItemStockReportPageState();
}

class _ItemStockReportPageState extends State<ItemStockReportPage> {
  bool _isLoading = false;

  List<ItemStockReport> _docs = [];
  Uint8List _uint8List = Uint8List(0);

  //Filters
  DateTime _date = DateTime.now();
  List<int>? _inventoryList;
  List<int>? _itemCategoryList;
  List<String>? _itemList;

  void _handleFilterChange(
    DateTime newDate,
    List<int>? newInventoryList,
    List<int>? newItemCategoryList,
    List<String>? newItemList,
  ) {
    setState(() {
      _date = newDate;
      _inventoryList = newInventoryList;
      _itemCategoryList = newItemCategoryList;
      _itemList = newItemList;
    });
  }
  // void _handleFetchDocuments() {
  //   _fetchDocuments();
  // }

  // Future<void> _initializeData() async {
  //   setState(() {
  //     _isLoading = true;
  //   });

  //   _date =
  //       DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  //   await _fetchDocuments();
  //   //await _generatePdf();

  //   setState(() {
  //     _isLoading = false;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    _fetchDocuments();
    // _initializeData();
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
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _generatePdf() async {
    try {
      final uint8List = await PdfItemStockReport.generate(
        _docs,
        DateFormat('yyyy-MM-dd').format(_date),
      );
      _uint8List = uint8List;
    } catch (error) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Text(
              'Raport Stocuri',
              style: CustomStyle.titleText,
            ),

            const Spacer(),

            const SizedBox(width: 10), // Adjust the spacing between the buttons
            SizedBox(
              height: 35,
              child: ElevatedButton.icon(
                style: CustomStyle.submitBlackButton,
                onPressed: () async {
                  await PdfItemStockReport.generate(
                    _docs,
                    DateFormat('yyyy/MM/dd').format(_date),
                  ).then((value) {
                    final blob = html.Blob([value], 'application/pdf');
                    final url = html.Url.createObjectUrlFromBlob(blob);

                    html.window.open(url, '_blank');
                  });
                },
                icon: const Icon(
                  Icons.file_download,
                  color: Colors.white,
                ),
                label: const Text(
                  'Printeaza',
                  style: CustomStyle.primaryButtonText,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            DropDownFilter(
              labelText: 'Categorii Produse',
              onValueChanged: (selectedList) {
                _itemCategoryList =
                    selectedList.map((item) => item.id!).toList();
                _fetchDocuments();
              },
              provider: itemCategoryProvider,
            ),
            const SizedBox(
              width: 8,
            ),
            DropDownFilter(
              labelText: 'Produse',
              onValueChanged: (selectedList) {
                _itemList = selectedList.map((item) => item.id!).toList();
                _fetchDocuments();
              },
              provider: itemsProvider,
            ),
            // DatePickerFilter(
            //   labelText: 'Data',
            //   onValueChanged: (startDate, endDate) {
            //     _documentFilter.startDate = startDate;
            //     _documentFilter.endDate = endDate;
            //     _fetchDocuments();
            //   },
            //   initialStartDate: _documentFilter.startDate,
            //   initialEndDate: _documentFilter.endDate,
            // ),
            Spacer(),
          ],
        ),
        // Add your other widgets here
        // FilterSectionLargeItemStockReport(
        //   onChanged: _handleFilterChange,
        //   onPressed: _handleFetchDocuments,
        // ),

        const SizedBox(height: 8),
        Expanded(child: ItemStockReportPageDataTable(data: _docs))
      ],
    );
  }
}
