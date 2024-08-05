import 'package:erp_frontend_v2/models/item/item_category_model.dart';
import 'package:erp_frontend_v2/models/item/vat_model.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../graphql/graphql_client.dart';
import '../graphql/queries/item.dart' as queries;
import '../graphql/mutations/item.dart' as mutations;
import '../models/item/item_model.dart';
import '../models/item/item_filter_model.dart';
import '../models/item/um_model.dart';

class ItemService {
  Future<List<Item>> getItems({
    required ItemFilter itemFilter,
  }) async {
    final QueryOptions options = QueryOptions(
      document: gql(queries.getItems),
      variables: <String, dynamic>{
        "input": {"category_list": itemFilter.categoryList}
      },
      fetchPolicy: FetchPolicy.noCache,
    );

    final QueryResult result = await graphQLClient.value.query(options);

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }
    final dynamic data = result.data!['getItems'];

    if (data != null && data is List<dynamic>) {
      final List<Item> items = data.map((json) => Item.fromJson(json)).toList();
      return items;
    } else {
      throw Exception('Invalid documents data');
    }
  }

  Future<String> saveItem({
    required Item item,
  }) async {
    final QueryOptions options = QueryOptions(
      document: gql(mutations.saveItem),
      variables: <String, dynamic>{
        "input": {
          "id": item.id,
          "code": item.code,
          "name": item.name,
          "id_um": item.um.id,
          "id_vat": item.vat.id,
          "is_stock": item.isStock,
          "is_active": item.isActive,
          "id_category": item.category?.id,
        }
      },
    );

    final QueryResult result = await graphQLClient.value.query(options);

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }
    final dynamic data = result.data!;

    if (data != null) {
      final String response = data['saveItem'];
      return response;
    } else {
      throw Exception('Invalid form data.');
    }
  }

  Future<List<Um>> getUmList() async {
    final QueryOptions options = QueryOptions(
      document: gql(queries.getUmList),
      fetchPolicy: FetchPolicy.noCache,
    );

    final QueryResult result = await graphQLClient.value.query(options);

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }
    final dynamic data = result.data!['getUmList'];
    if (data != null && data is List<dynamic>) {
      final List<Um> umList = data.map((json) => Um.fromJson(json)).toList();
      return umList;
    } else {
      throw Exception('Invalid data');
    }
  }

  Future<Um> saveUm({
    required Um um,
  }) async {
    final QueryOptions options = QueryOptions(
      document: gql(mutations.saveItemUnit),
      variables: <String, dynamic>{
        "input": um.toJson(),
      },
      fetchPolicy: FetchPolicy.noCache,
    );

    final QueryResult result = await graphQLClient.value.query(options);

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }
    final dynamic data = result.data!['saveUm'];

    if (data != null) {
      return Um.fromJson(data);
    } else {
      throw Exception('Invalid data');
    }
  }

  Future<List<Vat>> getVatList() async {
    final QueryOptions options = QueryOptions(
      document: gql(queries.getVatList),
      fetchPolicy: FetchPolicy.noCache,
    );

    final QueryResult result = await graphQLClient.value.query(options);

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }
    final dynamic data = result.data!['getVatList'];
    if (data != null && data is List<dynamic>) {
      final List<Vat> vatList = data.map((json) => Vat.fromJson(json)).toList();
      return vatList;
    } else {
      throw Exception('Invalid data');
    }
  }

  Future<List<ItemCategory>> getItemCategoryList() async {
    final QueryOptions options = QueryOptions(
      document: gql(queries.getItemCategoryList),
      fetchPolicy: FetchPolicy.noCache,
    );

    final QueryResult result = await graphQLClient.value.query(options);

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }
    final dynamic data = result.data!['getItemCategoryList'];
    if (data != null && data is List<dynamic>) {
      final List<ItemCategory> itemCategoryList =
          data.map((json) => ItemCategory.fromJson(json)).toList();
      return itemCategoryList;
    } else {
      throw Exception('Invalid data');
    }
  }

  Future<ItemCategory> saveItemCategory({
    required ItemCategory itemCategory,
  }) async {
    final QueryOptions options = QueryOptions(
      document: gql(mutations.saveItemCategory),
      variables: <String, dynamic>{
        "input": itemCategory.toJson(),
      },
      fetchPolicy: FetchPolicy.noCache,
    );

    final QueryResult result = await graphQLClient.value.query(options);

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }
    final dynamic data = result.data!['saveItemCategory'];

    if (data != null) {
      return ItemCategory.fromJson(data);
    } else {
      throw Exception('Invalid data');
    }
  }
}
