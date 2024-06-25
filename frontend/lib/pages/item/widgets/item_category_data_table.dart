import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/models/item/item_category_model.dart';
import 'package:erp_frontend_v2/pages/item/widgets/item_category_popup.dart';
import 'package:erp_frontend_v2/providers/item_provider.dart';
import 'package:erp_frontend_v2/widgets/buttons/edit_button.dart';
import 'package:erp_frontend_v2/widgets/custom_activ_status.dart';
import 'package:erp_frontend_v2/widgets/custom_data_table.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/style.dart';

class ItemCategoryDataTable extends ConsumerStatefulWidget {
  const ItemCategoryDataTable({
    super.key,
  });

  @override
  ConsumerState<ItemCategoryDataTable> createState() =>
      _ItemCategoryDataTableState();
}

class _ItemCategoryDataTableState extends ConsumerState<ItemCategoryDataTable> {
  String selectedHid = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final itemCategoryState = ref.watch(itemCategoryProvider);

    final List<DataColumn2> _columns = [
      DataColumn2(
        label: Text(
          'name'.tr(context),
          style: CustomStyle.labelSemibold16(color: CustomColor.greenGray),
        ),
        size: ColumnSize.L,
      ),
      DataColumn2(
        label: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('final_product'.tr(context),
                style:
                    CustomStyle.labelSemibold16(color: CustomColor.greenGray)),
            const SizedBox(width: 4),
            Tooltip(
              message: 'auto_generate_production_report'.tr(context),
              child: const Icon(
                Icons.info_outline_rounded,
                size: 20,
                color: CustomColor.greenGray,
              ),
            ),
          ],
        ),
        size: ColumnSize.L,
      ),
      DataColumn2(
          label: Container(
              alignment: Alignment.center,
              child: Text(
                'active'.tr(context),
                style:
                    CustomStyle.labelSemibold16(color: CustomColor.greenGray),
              )),
          size: ColumnSize.L),
      DataColumn2(
          label: Container(
              alignment: Alignment.center,
              child: Text(
                'edit'.tr(context),
                style:
                    CustomStyle.labelSemibold16(color: CustomColor.greenGray),
              )),
          fixedWidth: 100),
    ];

    return itemCategoryState.when(
      skipLoadingOnReload: true,
      skipLoadingOnRefresh: true,
      data: (itemCategoryList) {
        final rows = getRows(itemCategoryList);
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: CustomStyle.customContainerDecoration(),
          child: CustomDataTable(
            columns: _columns,
            rows: rows,
          ),
        );
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      error: (error, stackTrace) {
        return Text("Error: $error");
      },
    );
  }

  List<DataRow2> getRows(List<ItemCategory> categoryList) => categoryList
      .map((ItemCategory category) => DataRow2(
            cells: [
              DataCell(
                Text(
                  category.name,
                  style: CustomStyle.labelSemibold14(),
                ),
              ),
              DataCell(Container(
                alignment: Alignment.center,
                child: CustomActiveStatus(
                  isActive: category.isActive,
                ),
              )),
              DataCell(Container(
                alignment: Alignment.center,
                child: CustomActiveStatus(
                  isActive: category.generatePn,
                ),
              )),
              DataCell(Container(
                alignment: Alignment.center,
                child: CustomEditButton(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ItemCategoryPopup(
                          category: category,
                        );
                      },
                    );
                  },
                ),
              )),
            ],
          ))
      .toList();
}
