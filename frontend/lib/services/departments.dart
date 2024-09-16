import 'package:erp_frontend_v2/models/department_model.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../graphql/graphql_client.dart';
import '../graphql/queries/department.dart' as queries;
import '../graphql/mutations/department.dart' as mutations;

class DepartmentService {
  Future<List<Department>> getDepartmentList() async {
    final QueryOptions options = QueryOptions(
      document: gql(queries.getDepartments),
      fetchPolicy: FetchPolicy.noCache,
    );

    final QueryResult result = await graphQLClient.value.query(options);

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }
    final dynamic data = result.data!['getDepartments'];
    if (data != null && data is List<dynamic>) {
      final List<Department> departmentList =
          data.map((json) => Department.fromJson(json)).toList();
      return departmentList;
    } else {
      throw Exception('Invalid data');
    }
  }

  Future<Department> saveDepartment({
    required Department department,
  }) async {
    final QueryOptions options = QueryOptions(
      document: gql(mutations.saveDepartment),
      variables: <String, dynamic>{
        "input": {
          "id": department.id,
          "name": department.name,
          "flags": department.flags,
          "parents_ids": department.parents.map((parent) => parent.id).toList(),
        }
      },
      fetchPolicy: FetchPolicy.noCache,
    );

    final QueryResult result = await graphQLClient.value.query(options);

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }
    final dynamic data = result.data!['saveDepartment'];

    if (data != null) {
      return Department.fromJson(data);
    } else {
      throw Exception('Invalid data');
    }
  }
}
