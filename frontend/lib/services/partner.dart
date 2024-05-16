import 'package:graphql_flutter/graphql_flutter.dart';
import '../graphql/graphql_client.dart';
import '../graphql/queries/partner.dart' as queries;
import '../graphql/mutations/partner.dart' as mutations;
import '../models/partner/partner_model.dart';
import '../models/partner/partner_filter_model.dart';

class PartnerService {
  Future<List<Partner>> getPartners({
    required PartnerFilter partnerFilter,
  }) async {
    final QueryOptions options = QueryOptions(
      document: gql(queries.getPartners),
//       variables: <String, dynamic>{
//         "input": {
//           "code": '',
//           "name": null,
//           "type": null,
//           "tax_id": null,
//         }
//       },
      fetchPolicy: FetchPolicy.noCache,
    );

    final QueryResult result = await graphQLClient.value.query(options);

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }
    // await Future.delayed(Duration(seconds: 2));
    final dynamic partnerData = result.data!['getPartners'];
    if (partnerData != null && partnerData is List<dynamic>) {
      final List<Partner> partners =
          partnerData.map((json) => Partner.fromJson(json)).toList();
      return partners;
    } else {
      throw Exception('Invalid  data');
    }
  }

  Future<Partner> getPartnerByTaxId({
    required String taxId,
  }) async {
    final QueryOptions options = QueryOptions(
      document: gql(queries.getPartnerByTaxId),
      variables: <String, dynamic>{
        "taxId": taxId,
      },
      fetchPolicy: FetchPolicy.noCache,
    );

    final QueryResult result = await graphQLClient.value.query(options);

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }
    final dynamic partnerData = result.data!['getPartnerByTaxId'];
    if (partnerData != null) {
      final Partner partner = Partner.fromJson(partnerData);

      return partner;
    } else {
      throw Exception('Invalid documents data.');
    }
  }

  Future<String> savePartner({
    required Partner partner,
  }) async {
    final QueryOptions options = QueryOptions(
      document: gql(mutations.savePartner),
      variables: <String, dynamic>{
        "input": {
          "id": partner.id,
          "code": partner.code,
          "name": partner.name,
          "type": partner.type,
          "tax_id": partner.vatNumber,
          "company_number": partner.registrationNumber,
          "personal_id": partner.individualNumber,
          "is_active": partner.isActive,
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
      final String response = data['savePartner'];
      return response;
    } else {
      throw Exception('Invalid form data.');
    }
  }
}
