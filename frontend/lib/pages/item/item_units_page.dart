import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/pages/item/widgets/item_unit_popup.dart';
import 'package:erp_frontend_v2/pages/item/widgets/item_units_data_table.dart';
import 'package:erp_frontend_v2/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../helpers/responsiveness.dart';

class ItemUnitsPage extends StatefulWidget {
  const ItemUnitsPage({super.key});

  @override
  State<ItemUnitsPage> createState() => _ItemUnitsPageState();
}

class _ItemUnitsPageState extends State<ItemUnitsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomColor.white,
      padding: EdgeInsets.only(
        left: ResponsiveWidget.isSmallScreen(context) ? 0 : 24,
        right: ResponsiveWidget.isSmallScreen(context) ? 0 : 24,
        top: ResponsiveWidget.isSmallScreen(context) ? 56 : 32,
        bottom: ResponsiveWidget.isSmallScreen(context) ? 0 : 24,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'measurement_units'.tr(context),
                style: CustomStyle.medium40(),
              ),
              const Spacer(),
              PrimaryButton(
                text: 'Adauga',
                icon: Icons.add,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const ItemUnitPopup(
                        um: null,
                      );
                    },
                  );
                },
              ),
            ],
          ),
          const Gap(32),
          const Expanded(
            child: ItemUnitsDataTable(),
          )
        ],
      ),
    );
  }
}
