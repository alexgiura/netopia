import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/pages/item/item_details_page.dart';
import 'package:erp_frontend_v2/pages/item/widgets/items_page_data_table.dart';
import 'package:erp_frontend_v2/pages/partner/widgets/partner_page_data_table.dart';
import 'package:erp_frontend_v2/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import '../../utils/responsiveness.dart';

class ItemsPage extends StatefulWidget {
  const ItemsPage({super.key});

  @override
  State<ItemsPage> createState() => _PartnersPageState();
}

class _PartnersPageState extends State<ItemsPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'items'.tr(context),
              style: CustomStyle.medium40(),
            ),
            const Spacer(),
            PrimaryButton(
              text: 'add'.tr(context),
              icon: Icons.add,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const ItemDetailsPopup(
                      item: null,
                    );
                  },
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Flexible(
          child: ItemsPageDataTable(),
        )
      ],
    );
  }
}
