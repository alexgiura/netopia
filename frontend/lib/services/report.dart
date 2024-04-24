import 'package:erp_frontend_v2/graphql/graphql_client.dart';
import 'package:erp_frontend_v2/models/document/document_generate_model.dart';
import 'package:erp_frontend_v2/models/report/item_stock_report_model.dart';
import 'package:erp_frontend_v2/models/report/production_note_report_model.dart';
import 'package:erp_frontend_v2/models/report/report_filter_model.dart';
import 'package:erp_frontend_v2/models/report/spline_chart_model.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import '../graphql/queries/report.dart' as queries;

class ReportService {
  Future<List<SplineChartData>> getRevenueChart() async {
    final QueryOptions options = QueryOptions(
      document: gql(queries.getRevenueChart),
      fetchPolicy: FetchPolicy.noCache,
    );

    final QueryResult result = await graphQLClient.value.query(options);

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }
    final dynamic data = result.data!['getRevenueChart'];
    if (data != null && data is List<dynamic>) {
      final List<SplineChartData> vatList =
          data.map((json) => SplineChartData.fromJson(json)).toList();
      return vatList;
    } else {
      throw Exception('Invalid data');
    }
  }

  Future<List<ProductionNoteReport>> getProductionNoteReport({
    required ReportFilter reportFilter,
  }) async {
    final QueryOptions options = QueryOptions(
      document: gql(queries.getProductionNoteReport),
      variables: <String, dynamic>{
        "input": {
          "start_date": DateFormat('yyyy-MM-dd').format(reportFilter.startDate),
          "end_date": DateFormat('yyyy-MM-dd').format(reportFilter.endDate),
          "partners": reportFilter.partnerList,
        }
      },
      fetchPolicy: FetchPolicy.noCache,
    );

    final QueryResult result = await graphQLClient.value.query(options);

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }
    final dynamic data = result.data!['getProductionNoteReport'];
    if (data != null && data is List<dynamic>) {
      final List<ProductionNoteReport> productionNoteReportList =
          data.map((json) => ProductionNoteReport.fromJson(json)).toList();

      return productionNoteReportList;
    } else {
      throw Exception('Invalid data');
    }
  }

  Future<List<ItemStockReport>> getItemStockReport({
    required DateTime date,
    required List<int>? inventoryList,
    required List<int>? itemCategoryList,
    required List<String>? itemList,
  }) async {
    final QueryOptions options = QueryOptions(
      document: gql(queries.getItemStockReport),
      variables: <String, dynamic>{
        "input": {
          "date": DateFormat('yyyy-MM-dd').format(date).toString(),
          "inventory_list": inventoryList,
          "item_category_list": itemCategoryList,
          "item_list": itemList
        }
      },
      fetchPolicy: FetchPolicy.noCache,
    );

    final QueryResult result = await graphQLClient.value.query(options);

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }
    final dynamic data = result.data!['getStockReport'];
    if (data != null && data is List<dynamic>) {
      final List<ItemStockReport> itemStockReportList =
          data.map((json) => ItemStockReport.fromJson(json)).toList();

      return itemStockReportList;
    } else {
      throw Exception('Invalid data');
    }
  }

  Future<List<DocumentGenerate>> getTransactionAvailableItems({
    required List<String> partners,
    required int transactionId,
  }) async {
    final QueryOptions options = QueryOptions(
      document: gql(queries.getTransactionAvailableItems),
      variables: <String, dynamic>{
        "input": {
          "partners": partners,
          "transaction_id": transactionId,
        }
      },
      fetchPolicy: FetchPolicy.noCache,
    );

    final QueryResult result = await graphQLClient.value.query(options);

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }
    final dynamic data = result.data!['getTransactionAvailableItems'];

    if (data != null && data is List<dynamic>) {
      final List<DocumentGenerate> docs =
          data.map((json) => DocumentGenerate.fromJson(json)).toList();

      return docs;
    } else {
      throw Exception('Invalid documents data.');
    }
  }
}
