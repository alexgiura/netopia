import 'dart:typed_data';

import 'package:erp_frontend_v2/constants/theme.dart';
import 'package:erp_frontend_v2/layout.dart';
import 'package:erp_frontend_v2/pages/auth/auth_page.dart';
import 'package:erp_frontend_v2/pages/dashboard/dashboard_page.dart';
import 'package:erp_frontend_v2/pages/document/document_details_page/document_details_page.dart';
import 'package:erp_frontend_v2/pages/item/item_category_page.dart';
import 'package:erp_frontend_v2/pages/item/item_units_page.dart';
import 'package:erp_frontend_v2/pages/item/items_page.dart';
import 'package:erp_frontend_v2/pages/production/production_recipe_details_page.dart';
import 'package:erp_frontend_v2/pages/report/item_stock/item_stock_report_page.dart';
import 'package:erp_frontend_v2/pages/report/production_note/production_note_report_page.dart';
import 'package:erp_frontend_v2/pages/report/transaction_available_items/transaction_available_items_report_page.dart';
import 'package:erp_frontend_v2/pages/settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/menu_model.dart';
import '../pages/document/documents_page/documents_page.dart';
import '../pages/partner/partners_page.dart';
import '../pages/production/production_recipes_page.dart';
import '../pdf/pdf_viewer.dart';
import 'routes.dart';

//final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

/// The route configuration.
final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      name: authenticationPageName,
      path: authenticationPageRoute,
      builder: (BuildContext context, GoRouterState state) {
        return const AuthPage();
      },
    ),
    ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return AppLayout(child: child);
        },
        routes: [
          GoRoute(
            path: settingsPageRoute,
            builder: (BuildContext context, GoRouterState state) {
              return const SettingsPage();
            },
          ),

          GoRoute(
            path: overviewPageRoute,
            builder: (BuildContext context, GoRouterState state) {
              return const DashboardPage();
            },
          ),

          // Items route
          GoRoute(
            path: itemsRoute,
            builder: (BuildContext context, GoRouterState state) {
              return const ItemsPage();
            },
          ),

          // Item Category route
          GoRoute(
            path: itemCategoryRoute,
            builder: (BuildContext context, GoRouterState state) {
              return const ItemCategoryPage();
            },
          ),

          // Measurement Units route
          GoRoute(
            path: unitsRoute,
            builder: (BuildContext context, GoRouterState state) {
              return const ItemUnitsPage();
            },
          ),

          // Partners route
          GoRoute(
            path: partnersRoute,
            builder: (BuildContext context, GoRouterState state) {
              return const PartnersPage();
            },
          ),

          // // Test route
          // GoRoute(
          //   path: testRoute,
          //   builder: (BuildContext context, GoRouterState state) {
          //     return const TestPage();
          //   },
          // ),

          //Client
          // Client Delivery Note Route
          GoRoute(
            name: clientDeliveryNotePageName,
            path: clientDeliveryNoteRoute,
            builder: (BuildContext context, GoRouterState state) {
              return const DocumentsPage(
                documentTypeId: 4,
                documentTitle: clientDeliveryNotePageName,
              );
            },
            // Subroutes
            routes: <RouteBase>[
              GoRoute(
                path: clientDeliveryNoteDetailsRoute,
                name: clientDeliveryNoteDetailsPageName,
                pageBuilder: (context, state) {
                  final hId = state.pathParameters['id1'] ?? '';

                  return CustomTransitionPage(
                      child: DocumentDetailsPage(
                        hId: hId,
                        documentTypeId: 4,
                        pageTitle: clientDeliveryNoteDetailsPageName,
                      ),
                      transitionsBuilder: customSlideTransition);
                },
              ),
            ],
          ),

          // Client Invoice Route
          GoRoute(
            name: clientInvoicePageName,
            path: clientInvoiceRoute,
            builder: (BuildContext context, GoRouterState state) {
              return const DocumentsPage(
                documentTypeId: 2,
                documentTitle: clientInvoicePageName,
              );
            },
            // Subroutes
            routes: <RouteBase>[
              GoRoute(
                path: clientInvoiceDetailsRoute, //
                name: clientInvoiceDetailsPageName,
                pageBuilder: (context, state) {
                  final hId = state.pathParameters['id1'] ?? '';

                  return CustomTransitionPage(
                      child: DocumentDetailsPage(
                        hId: hId,
                        documentTypeId: 2,
                        pageTitle: clientInvoiceDetailsPageName,
                      ),
                      transitionsBuilder: customSlideTransition);
                },
              ),
            ],
          ),

          //Supplier

          // Client Delivery Note Route
          GoRoute(
            name: supplierDeliveryNotePageName,
            path: supplierDeliveryNoteRoute,
            builder: (BuildContext context, GoRouterState state) {
              return const DocumentsPage(
                documentTypeId: 3,
                documentTitle: supplierDeliveryNotePageName,
              );
            },
            // Subroutes
            routes: <RouteBase>[
              GoRoute(
                path: supplierDeliveryNoteDetailsRoute, //
                name: supplierDeliveryNoteDetailsPageName,
                pageBuilder: (context, state) {
                  final hId = state.pathParameters['id1'] ?? '';

                  return CustomTransitionPage(
                      child: DocumentDetailsPage(
                        hId: hId,
                        documentTypeId: 3,
                        pageTitle: supplierDeliveryNoteDetailsPageName,
                      ),
                      transitionsBuilder: customSlideTransition);
                },
              ),
            ],
          ),

          GoRoute(
            path: pdfRoute,
            name: pdfPageName,
            builder: (context, state) {
              final Map<String, dynamic> extras =
                  state.extra as Map<String, dynamic>;
              final Uint8List bytes = extras['bytes'] as Uint8List;
              return PdfViewerPage(
                bytes: bytes,
              );
            },
          ),

          // Client Invoice Route
          GoRoute(
            name: supplierInvoicePageName,
            path: supplierInvoiceRoute,
            builder: (BuildContext context, GoRouterState state) {
              return const DocumentsPage(
                documentTypeId: 1,
                documentTitle: supplierInvoicePageName,
              );
            },
            // Subroutes
            routes: <RouteBase>[
              GoRoute(
                path: supplierInvoiceDetailsRoute, //
                name: supplierInvoiceDetailsPageName,
                pageBuilder: (context, state) {
                  final hId = state.pathParameters['id1'] ?? '';

                  return CustomTransitionPage(
                      child: DocumentDetailsPage(
                        hId: hId,
                        documentTypeId: 1,
                        pageTitle: supplierInvoiceDetailsPageName,
                      ),
                      transitionsBuilder: customSlideTransition);
                },
              ),
            ],
          ),

          // Goods Received Route
          GoRoute(
            name: goodsReceivedNotesPageName,
            path: goodsReceivedNotesRoute,
            builder: (BuildContext context, GoRouterState state) {
              return const DocumentsPage(
                documentTypeId: 5,
                documentTitle: goodsReceivedNotesPageName,
              );
            },
            // Subroutes
            routes: <RouteBase>[
              GoRoute(
                path: goodsReceivedNoteDetailsRoute, //
                name: goodsReceivedNoteDetailsPageName,
                pageBuilder: (context, state) {
                  final hId = state.pathParameters['id1'] ?? '';

                  return CustomTransitionPage(
                      child: DocumentDetailsPage(
                        hId: hId,
                        documentTypeId: 5,
                        pageTitle: goodsReceivedNoteDetailsPageName,
                      ),
                      transitionsBuilder: customSlideTransition);
                },
              ),
            ],
          ),

          //Inventory

          // Consumption Note Route
          GoRoute(
            name: consumptionNotePageName,
            path: consumptionNoteRoute,
            builder: (BuildContext context, GoRouterState state) {
              return const DocumentsPage(
                documentTypeId: 6,
                documentTitle: consumptionNotePageName,
              );
            },
            // Subroutes
            routes: <RouteBase>[
              GoRoute(
                path: consumptionNoteDetailsRoute, //
                name: consumptionNoteDetailsPageName,
                pageBuilder: (context, state) {
                  final hId = state.pathParameters['id1'] ?? '';

                  return CustomTransitionPage(
                      child: DocumentDetailsPage(
                        hId: hId,
                        documentTypeId: 6,
                        pageTitle: consumptionNoteDetailsPageName,
                      ),
                      transitionsBuilder: customSlideTransition);
                },
              ),
            ],
          ),

          // Receipt Note Route
          GoRoute(
            name: receiptNotePageName,
            path: receiptNoteRoute,
            builder: (BuildContext context, GoRouterState state) {
              return const DocumentsPage(
                documentTypeId: 7,
                documentTitle: receiptNotePageName,
              );
            },
            // Subroutes
            routes: <RouteBase>[
              GoRoute(
                path: receiptNoteDetailsRoute, //
                name: receiptNoteDetailsPageName,
                pageBuilder: (context, state) {
                  final hId = state.pathParameters['id1'] ?? '';

                  return CustomTransitionPage(
                      child: DocumentDetailsPage(
                        hId: hId,
                        documentTypeId: 7,
                        pageTitle: receiptNoteDetailsPageName,
                      ),
                      transitionsBuilder: customSlideTransition);
                },
              ),
            ],
          ),

          //Production
          // Production Note Route
          GoRoute(
            name: productionNotePageName,
            path: productionNoteRoute,
            builder: (BuildContext context, GoRouterState state) {
              return const DocumentsPage(
                documentTypeId: 8,
                documentTitle: productionNotePageName,
              );
            },
            // Subroutes
            routes: <RouteBase>[
              GoRoute(
                path: productionNoteDetailsRoute,
                name: productionNoteDetailsPageName,
                pageBuilder: (context, state) {
                  final hId = state.pathParameters['id1'] ?? '';

                  return CustomTransitionPage(
                      child: DocumentDetailsPage(
                        hId: hId,
                        documentTypeId: 8,
                        pageTitle: productionNoteDetailsPageName,
                      ),
                      transitionsBuilder: customSlideTransition);
                },
              ),
            ],
          ),

          // Production Recipes route
          GoRoute(
            name: productionRecipePageName,
            path: productionRecipeRoute,
            builder: (BuildContext context, GoRouterState state) {
              return const ProductionRecipesPage();
            },
            // Subroutes
            routes: <RouteBase>[
              GoRoute(
                path: productionRecipeDetailsRoute,
                name: productionRecipeDetailsPageName,
                pageBuilder: (context, state) {
                  final id = state.pathParameters['id1'] ?? '';
                  // Check if `state.extra` is provided, otherwise set `refreshCallback` to null
                  void Function()? refreshCallback = state.extra != null
                      ? state.extra as void Function()
                      : null;
                  return CustomTransitionPage(
                      child: ProductionRecipeDetailsPage(
                        id: id,
                        refreshCallback: refreshCallback,
                      ),
                      transitionsBuilder: customSlideTransition);
                },
              ),
            ],
          ),

          //Report
          GoRoute(
            path: productionNoteReportRoute,
            builder: (BuildContext context, GoRouterState state) {
              return const ProductionNoteReportPage(
                  documentTitle: productionNoteReportPageName);
            },
          ),
          GoRoute(
            path: itemStockReportRoute,
            builder: (BuildContext context, GoRouterState state) {
              return const ItemStockReportPage();
            },
          ),
          GoRoute(
            path: unbilledClientDeliveryNotesReportRoute,
            builder: (BuildContext context, GoRouterState state) {
              return const AvailableItemsReportPage(
                  transactionId: 1,
                  documentTitle: unbilledClientDeliveryNotesReportPageName);
            },
          ),
          GoRoute(
            path: unrecivedSupplierDeliveryNotesReportRoute,
            builder: (BuildContext context, GoRouterState state) {
              return const AvailableItemsReportPage(
                  transactionId: 7,
                  documentTitle: unrecivedSupplierDeliveryNotesReportPageName);
            },
          ),
        ]),
  ],
);

List<String> generateRoute(Menu menuItem) {
  switch (menuItem.title) {
    case 'Parteneri':
      return [partnersRoute];
    case 'Produse':
      return [itemsRoute];
    case 'Tip Produse':
      return [itemCategoryRoute];
    case 'Unități de Măsură':
      return [unitsRoute];
    case 'Avize Client':
      return [clientDeliveryNoteRoute];
    case 'Facturi Client':
      return [clientInvoiceRoute];
    case 'Avize Furnizor':
      return [supplierDeliveryNoteRoute];
    case 'Facturi Furnizor':
      return [supplierInvoiceRoute];
    case 'NIR-uri':
      return [goodsReceivedNotesRoute];
    case 'Bon de Consum':
      return [consumptionNoteRoute];
    case 'Nota de Predare':
      return [receiptNoteRoute];
    case 'Rapoarte Producție':
      return [productionNoteRoute];
    case 'Rețete':
      return [productionRecipeRoute];
    case 'Print Raport Producție':
      return [productionNoteReportRoute];
    case 'Stocuri':
      return [itemStockReportRoute];
    case 'Avize Client Nefacturate':
      return [unbilledClientDeliveryNotesReportRoute];
    case 'Avize Furnizor Nerecepționate':
      return [unrecivedSupplierDeliveryNotesReportRoute];

    default:
      return [overviewPageRoute, menuItem.title];
  }
}

String getDetailsRouteNameByDocumentType(int documentTypeId) {
  switch (documentTypeId) {
    case 1:
      return supplierInvoiceDetailsPageName;
    case 2:
      return clientInvoiceDetailsPageName;
    case 3:
      return supplierDeliveryNoteDetailsPageName;
    case 4:
      return clientDeliveryNoteDetailsPageName;
    case 5:
      return goodsReceivedNoteDetailsPageName;
    case 6:
      return consumptionNoteDetailsPageName;
    case 7:
      return receiptNoteDetailsPageName;
    case 8:
      return productionNoteDetailsPageName;

    default:
      return 'ClientInvoiceDetails'; // Some default or error route
  }
}
