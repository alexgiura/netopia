import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/models/item/um_model.dart';
import 'package:erp_frontend_v2/pages/item/widgets/item_unit_popup.dart';
import 'package:erp_frontend_v2/providers/item_provider.dart';
import 'package:erp_frontend_v2/widgets/buttons/edit_button.dart';
import 'package:erp_frontend_v2/widgets/custom_activ_status.dart';
import 'package:erp_frontend_v2/widgets/custom_data_table.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/style.dart';

class ItemUnitsDataTable extends ConsumerStatefulWidget {
  const ItemUnitsDataTable({
    super.key,
  });

  @override
  ConsumerState<ItemUnitsDataTable> createState() => _ItemUnitsDataTableState();
}

class _ItemUnitsDataTableState extends ConsumerState<ItemUnitsDataTable> {
  String selectedHid = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final itemUnitsState = ref.watch(itemUnitsProvider);

    final List<DataColumn2> _columns = [
      DataColumn2(
        label: Text(
          'name'.tr(context),
          style: CustomStyle.semibold16(color: CustomColor.greenGray),
        ),
        size: ColumnSize.L,
      ),
      DataColumn2(
        label: Text(
          'efactura_code'.tr(context),
          style: CustomStyle.semibold16(color: CustomColor.greenGray),
        ),
        size: ColumnSize.L,
      ),
      DataColumn2(
          label: Container(
              alignment: Alignment.center,
              child: Text(
                'active'.tr(context),
                style: CustomStyle.semibold16(color: CustomColor.greenGray),
              )),
          size: ColumnSize.M),
      DataColumn2(
          label: Container(
              alignment: Alignment.center,
              child: Text(
                'details'.tr(context),
                style: CustomStyle.semibold16(color: CustomColor.greenGray),
              )),
          fixedWidth: 60),
    ];

    return itemUnitsState.when(
      skipLoadingOnReload: true,
      skipLoadingOnRefresh: true,
      data: (itemUnitsList) {
        final rows = getRows(itemUnitsList);
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

  List<DataRow2> getRows(List<Um> umList) => umList
      .map((Um um) => DataRow2(
            cells: [
              DataCell(
                Text(
                  um.name,
                  style: CustomStyle.semibold14(),
                ),
              ),
              DataCell(Text(
                um.code,
                style: CustomStyle.semibold14(),
              )),
              DataCell(Container(
                alignment: Alignment.center,
                child: CustomActiveStatus(
                  isActive: um.isActive,
                ),
              )),
              DataCell(Container(
                alignment: Alignment.center,
                child: CustomEditButton(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ItemUnitPopup(
                          um: um,
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
