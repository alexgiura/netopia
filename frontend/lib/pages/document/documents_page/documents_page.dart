import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/widgets/buttons/primary_button.dart';
import 'package:erp_frontend_v2/widgets/custom_header_widget.dart';
import 'package:erp_frontend_v2/widgets/custom_search_bar.dart';
import 'package:erp_frontend_v2/widgets/custom_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../utils/responsiveness.dart';
import '../../../routing/router.dart';
import 'widgets/documents_data_table.dart';

class DocumentsPage extends StatefulWidget {
  final int documentTypeId;
  final String documentTitle;
  final String? documentSubtitle;
  const DocumentsPage(
      {super.key,
      required this.documentTypeId,
      required this.documentTitle,
      this.documentSubtitle});

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  String? _status;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: ResponsiveWidget.isSmallScreen(context) ? 0 : 24,
        right: ResponsiveWidget.isSmallScreen(context) ? 0 : 24,
        top: ResponsiveWidget.isSmallScreen(context) ? 24 : 32,
        bottom: ResponsiveWidget.isSmallScreen(context) ? 0 : 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  child: CustomHeader(
                title: widget.documentTitle,
                subtitle: widget.documentSubtitle,
              )),
              const Spacer(),
              PrimaryButton(
                text: 'add'.tr(context),
                icon: Icons.add,
                onPressed: () {
                  final routeName =
                      getDetailsRouteNameByDocumentType(widget.documentTypeId);
                  context.goNamed(
                    routeName,
                    pathParameters: {'id1': '0'},
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Flexible(
            child: DocumentsDataTable(
              documentTypeId: widget.documentTypeId,
              status: _status,
            ),
          )
        ],
      ),
    );
  }
}
