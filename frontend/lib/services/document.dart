import 'package:erp_frontend_v2/models/document/document_generate_model.dart';
import 'package:erp_frontend_v2/models/document/document_light_model.dart';
import 'package:erp_frontend_v2/models/document/document_transaction_model.dart';
import 'package:erp_frontend_v2/models/document/documents_filter_model.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import '../graphql/graphql_client.dart';
import '../graphql/queries/document.dart' as queries;
import '../graphql/mutations/document.dart' as mutations;
import '../models/document/document_model.dart';

class DocumentService {
  Future<List<DocumentLight>> getDocuments({
    required DocumentFilter documentFilter,
  }) async {
    final QueryOptions options = QueryOptions(
      document: gql(queries.getDocuments),
      variables: <String, dynamic>{
        "input": {
          "document_type": documentFilter.documentTypeId,
          "start_date":
              DateFormat('yyyy-MM-dd').format(documentFilter.startDate),
          "end_date": DateFormat('yyyy-MM-dd').format(documentFilter.endDate),
          "status": documentFilter.status,
          "partner": documentFilter.partnerList
        }
      },
      fetchPolicy: FetchPolicy.noCache,
    );

    final QueryResult result = await graphQLClient.value.query(options);

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }
    final dynamic documentData = result.data!['getDocuments'];

    if (documentData != null && documentData is List<dynamic>) {
      final List<DocumentLight> docs =
          documentData.map((json) => DocumentLight.fromJson(json)).toList();
      return docs;
    } else {
      throw Exception('Invalid documents data.');
    }
  }

  Future<Document> getDocumentById({
    required String? documentId,
  }) async {
    final QueryOptions options = QueryOptions(
      document: gql(queries.getDocumentById),
      variables: <String, dynamic>{"documentId": documentId},
      fetchPolicy: FetchPolicy.noCache,
    );

    final QueryResult result = await graphQLClient.value.query(options);

    if (result.hasException) {
      print(result.exception.toString());
      throw Exception(result.exception.toString());
    }

    final dynamic documentData = result.data!['getDocumentById'];

    if (documentData != null) {
      final Document doc = Document.fromJson(documentData);

      return doc;
    } else {
      throw Exception('Invalid documents data.');
    }
  }

  Future<String> saveDocument({
    required Document document,
    int? transactionId,
  }) async {
    final List<Map<String, dynamic>> documentItemsList =
        document.documentItems.map((item) {
      return {
        "item_id": item.id,
        "quantity": item.quantity,
        "price": item.price,
        "amount_net": item.amountNet,
        "amount_vat": item.amountVat,
        "amount_gross": item.amountGross,
        "generated_d_id": item.generatedDId,
        "item_type_pn": item.itemTypePn
      };
    }).toList();
    final QueryOptions options = QueryOptions(
      document: gql(mutations.saveDocument),
      variables: <String, dynamic>{
        "input": {
          "document_type": document.documentType.id,
          "series": document.series,
          "number": document.number,
          "date": document.date,
          "partner_id": document.partner!.id,
          "person_id": document.personId,
          "recipe_id": document.recipeId,
          "notes": document.notes,
          "transaction_id": transactionId,
          "document_items": documentItemsList
        }
      },
      fetchPolicy: FetchPolicy.noCache,
    );

    final QueryResult result = await graphQLClient.value.query(options);

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }
    final dynamic data = result.data!;

    if (data != null) {
      final String response = data['saveDocument'];
      return response;
    } else {
      throw Exception('Invalid form data.');
    }
  }

  Future<List<DocumentTransaction>> getDocumentTransactions() async {
    final QueryOptions options = QueryOptions(
      document: gql(queries.getDocumentTransactions),
      fetchPolicy: FetchPolicy.noCache,
    );

    final QueryResult result = await graphQLClient.value.query(options);

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }
    final dynamic data = result.data!['getDocumentTransactions'];

    if (data != null && data is List<dynamic>) {
      final List<DocumentTransaction> docs =
          data.map((json) => DocumentTransaction.fromJson(json)).toList();
      return docs;
    } else {
      throw Exception('Invalid data');
    }
  }

  Future<List<DocumentGenerate>> getDocumentGenerate({
    required String partnerId,
    required int documentTypeId,
    required String date,
    required int transactionId,
  }) async {
    final QueryOptions options = QueryOptions(
      document: gql(queries.getGenerateAvailableItems),
      variables: <String, dynamic>{
        "input": {
          "partner_id": partnerId,
          "document_type_id": documentTypeId,
          "date": date,
          "transaction_id": transactionId,
        }
      },
      fetchPolicy: FetchPolicy.noCache,
    );

    final QueryResult result = await graphQLClient.value.query(options);

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }
    final dynamic data = result.data!['getGenerateAvailableItems'];

    if (data != null && data is List<dynamic>) {
      final List<DocumentGenerate> docs =
          data.map((json) => DocumentGenerate.fromJson(json)).toList();

      return docs;
    } else {
      throw Exception('Invalid documents data.');
    }
  }

  Future<String> deleteDocument({
    required String hId,
    required bool deleteGenerated,
  }) async {
    final QueryOptions options = QueryOptions(
      document: gql(mutations.deleteDocument),
      variables: <String, dynamic>{
        "input": {"h_id": hId, "delete_generated": deleteGenerated}
      },
      fetchPolicy: FetchPolicy.noCache,
    );

    final QueryResult result = await graphQLClient.value.query(options);

    if (result.hasException) {
      final message = result.exception!.graphqlErrors.first.message;
      throw message;
    }
    final dynamic data = result.data!;

    if (data != null) {
      final String response = data['deleteDocument'];
      return response;
    } else {
      throw Exception('Invalid form data.');
    }
  }
}
