import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/pages/production/widgets/production_notes_data_table.dart';
import 'package:erp_frontend_v2/routing/routes.dart';
import 'package:erp_frontend_v2/widgets/buttons/primary_button.dart';
import 'package:erp_frontend_v2/widgets/buttons/tertiary_button.dart';
import 'package:erp_frontend_v2/widgets/custom_header_widget.dart';
import 'package:erp_frontend_v2/widgets/custom_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../utils/responsiveness.dart';
import '../../../routing/router.dart';

class ProductionNotesPage extends StatefulWidget {
  final int documentTypeId;
  final String documentTitle;
  final String? documentSubtitle;
  const ProductionNotesPage(
      {super.key,
      required this.documentTypeId,
      required this.documentTitle,
      this.documentSubtitle});

  @override
  State<ProductionNotesPage> createState() => _ProductionNotesPageState();
}

class _ProductionNotesPageState extends State<ProductionNotesPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
          child: ProductionNotesDataTable(
            documentTypeId: widget.documentTypeId,
          ),
        )
      ],
    );
  }
}
