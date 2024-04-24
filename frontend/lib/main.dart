import 'package:erp_frontend_v2/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'graphql/graphql_client.dart';

void main() {
  runApp(
    ProviderScope(child: App()),
  );
}
