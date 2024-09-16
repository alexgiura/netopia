import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

final httpLink = HttpLink('http://206.189.7.255:8080/graphql', defaultHeaders: {
  'Authorization':
      'Bearer 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',
  // 'Content-Type': 'application/json',
  // 'Accept': '*/*'
});

final graphQLClient = ValueNotifier<GraphQLClient>(
  GraphQLClient(
    cache: GraphQLCache(),
    link: httpLink,
  ),
);
