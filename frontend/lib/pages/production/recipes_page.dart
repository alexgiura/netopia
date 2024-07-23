import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/pages/item/widgets/item_unit_popup.dart';
import 'package:erp_frontend_v2/pages/item/widgets/item_units_data_table.dart';
import 'package:erp_frontend_v2/pages/production/widgets/recipes_data_table.dart';
import 'package:erp_frontend_v2/routing/routes.dart';
import 'package:erp_frontend_v2/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../utils/responsiveness.dart';

class ProductionRecipesPage extends StatefulWidget {
  const ProductionRecipesPage({super.key});

  @override
  State<ProductionRecipesPage> createState() => _ProductionRecipesPageState();
}

class _ProductionRecipesPageState extends State<ProductionRecipesPage> {
  @override
  void initState() {
    super.initState();
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                'recipes'.tr(context),
                style: CustomStyle.medium40(),
              ),
              const Spacer(),
              PrimaryButton(
                text: 'add'.tr(context),
                icon: Icons.add,
                onPressed: () {
                  context.goNamed(
                    productionRecipeDetailsPageName,
                    pathParameters: {'id1': '0'},
                  );
                },
              ),
            ],
          ),
          const Gap(24),
          const Flexible(
            child: RecipesDataTable(),
          )
        ],
      ),
    );
  }
}
