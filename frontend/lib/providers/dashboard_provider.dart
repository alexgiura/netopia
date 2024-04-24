import 'package:erp_frontend_v2/models/report/item_stock_report_model.dart';
import 'package:erp_frontend_v2/services/report.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final itemStockChartProvider =
    FutureProvider<List<ItemStockReport>>((ref) async {
  final document = await ReportService().getItemStockReport(
      date: DateTime.now(),
      inventoryList: null,
      itemCategoryList: [1],
      itemList: null);
  return document;
});
