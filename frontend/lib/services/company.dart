import 'package:erp_frontend_v2/graphql/graphql_client.dart';
import 'package:erp_frontend_v2/models/company/company_model.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../graphql/queries/company.dart' as queries;

class CompanyService {
  Future<Company?> getCompany(String? taxId) async {
    final QueryOptions options = QueryOptions(
      document: gql(queries.getCompany),
      variables: <String, dynamic>{
        "taxId": taxId,
      },
    );

    final QueryResult result = await graphQLClient.value.query(options);

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }
    final dynamic data = result.data!['getCompany'];

    if (data != null) {
      final Company company = Company.fromJson(data);

      return company;
    } else {
      return null;
    }
  }

  Future<Company?> getCompanyByTaxId(String taxId) async {
    final QueryOptions options = QueryOptions(
      document: gql(queries.getCompanyByTaxId),
      variables: <String, dynamic>{
        "taxId": taxId,
      },
      fetchPolicy: FetchPolicy.noCache,
    );

    final QueryResult result = await graphQLClient.value.query(options);

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }
    final dynamic data = result.data!['getCompanyByTaxId'];

    if (data != null) {
      final Company company = Company.fromJson(data);

      return company;
    } else {
      throw Exception('Invalid company data.');
    }
  }
}
