import 'dart:typed_data';

import 'package:erp_frontend_v2/constants/theme.dart';
import 'package:erp_frontend_v2/layout.dart';
import 'package:erp_frontend_v2/pages/item/departments_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/menu_model.dart';
import 'routes.dart';

//final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

/// The route configuration.
final GoRouter router = GoRouter(
  routes: <RouteBase>[
    ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return AppLayout(child: child);
        },
        routes: [
          GoRoute(
            path: departmentsPageRoute,
            builder: (BuildContext context, GoRouterState state) {
              return const DepartmentsPage();
            },
          ),
        ]),
  ],
);

List<String> generateRoute(Menu menuItem) {
  switch (menuItem.title) {
    case 'Produse':
      return [departmentsPageRoute];

    default:
      return [departmentsPageRoute, menuItem.title];
  }
}
