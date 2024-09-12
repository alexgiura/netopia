import 'package:erp_frontend_v2/graphql/graphql_client.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../graphql/mutations/eFactura.dart' as mutations;

class EfacturaService {
  Future<String> generateEfacturaAuthorizationLink() async {
    try {
      final QueryOptions options = QueryOptions(
        document: gql(mutations.generateEfacturaAuthorizationLink),
        fetchPolicy: FetchPolicy.noCache,
      );

      final QueryResult result = await graphQLClient.value.query(options);

      if (result.hasException) {
        throw Exception(result.exception.toString());
      }
      final dynamic data = result.data!['generateEfacturaAuthorizationLink'];

      if (data != null) {
        return data;
      } else {
        throw Exception('Invalid data');
      }
    } catch (e) {
      throw Exception('An error occurred: ${e.toString()}');
    }
  }

  Future<String> uploadEfacturaDocument({
    required List<String> hIdList,
    required bool regenerate,
  }) async {
    try {
      final QueryOptions options = QueryOptions(
        document: gql(mutations.uploadEfacturaDocument),
        variables: <String, dynamic>{
          "input": {
            "h_id_list": hIdList,
            "regenerate": regenerate,
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
        final String response = data['uploadEfacturaDocument'];
        return response;
      } else {
        throw Exception('Invalid data');
      }
    } catch (e) {
      throw Exception('An error occurred: ${e.toString()}');
    }
  }
}
