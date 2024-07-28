import 'package:erp_frontend_v2/models/user/user.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../graphql/graphql_client.dart';
import '../graphql/queries/user.dart' as queries;
import '../graphql/mutations/user.dart' as mutations;

class UserService {
  Future<User> getUser(String userId) async {
    final QueryOptions options = QueryOptions(
      document: gql(queries.getUser),
      variables: <String, dynamic>{
        "userId": userId,
      },
      fetchPolicy: FetchPolicy.noCache,
    );

    final QueryResult result = await graphQLClient.value.query(options);

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final dynamic userData = result.data!['getUser'];
    if (userData != null) {
      final User user = User.fromJson(userData);

      return user;
    } else {
      throw Exception('Invalid data.');
    }
  }

  Future<User> saveUser(User user) async {
    final MutationOptions options = MutationOptions(
      document: gql(mutations.saveUser),
      variables: <String, dynamic>{
        'input': user.toJson(),
      },
    );
    final QueryResult result = await graphQLClient.value.mutate(options);
    if (result.hasException) {
      throw result.exception!;
    }

    final dynamic userData = result.data!['createNewAccount'];

    if (userData != null) {
      final User user = User.fromJson(userData);

      return user;
    } else {
      throw Exception('Invalid data.');
    }
  }
}
