import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/pages/item/widgets/item_category_data_table.dart';
import 'package:erp_frontend_v2/pages/item/widgets/item_category_popup.dart';
import 'package:erp_frontend_v2/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../utils/responsiveness.dart';

class ItemCategoryPage extends StatefulWidget {
  const ItemCategoryPage({super.key});

  @override
  State<ItemCategoryPage> createState() => _ItemCategoryPageState();
}

class _ItemCategoryPageState extends State<ItemCategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'item_category'.tr(context),
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
                    return const ItemCategoryPopup(
                      category: null,
                    );
                  },
                );
              },
            ),
          ],
        ),
        const Gap(24),
        const Flexible(child: ItemCategoryDataTable())
      ],
    );
  }
}
