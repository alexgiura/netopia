import 'package:erp_frontend_v2/models/item/um_model.dart';
import 'package:erp_frontend_v2/pages/item/widgets/item_unit_popup.dart';
import 'package:erp_frontend_v2/providers/item_provider.dart';
import 'package:erp_frontend_v2/widgets/buttons/edit_button.dart';
import 'package:erp_frontend_v2/widgets/custom_activ_status.dart';
import 'package:erp_frontend_v2/widgets/custom_data_table.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
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

    return Container(
      padding: const EdgeInsets.only(top: 16),
      decoration: CustomStyle.customContainerDecoration(),
      child: itemUnitsState.when(
        skipLoadingOnReload: true,
        skipLoadingOnRefresh: true,
        data: (itemUnitsList) {
          // return Column(
          //   children: [
          //     Container(height: 100, width: 100, color: Colors.black),
          //   ],
          // );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CustomDataTable(
                  // showCheckbox: true,
                  columns: _columns,
                  rows: getRows(itemUnitsList),
                  // onSelectRows: (selectedRows) {
                  //   // List<Partner> selectedPartners =
                  //   //     selectedRows.map((index) => documentList[index]).toList();
                  // },
                ),
              ),
            ],
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
      ),
    );
  }

  List<DataRow2> getRows(List<Um> data) {
    return data.asMap().entries.map((row) {
      return DataRow2(
        cells: [
          DataCell(Text(row.value.name)),
          DataCell(Text(row.value.code)),
          DataCell(CustomActiveStatus(
            isActive: row.value.isActive,
          )),
          DataCell(CustomEditButton(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ItemUnitPopup(
                    um: row.value,
                  );
                },
              );
            },
          )),
        ],
      );
    }).toList();
  }
}

List<DataColumn2> _columns = [
  const DataColumn2(
    label: Text('Denumire'),
    size: ColumnSize.L,
  ),

  const DataColumn2(
    label: Text('Cod e-Factură'),
    size: ColumnSize.M,
  ),

  const DataColumn2(
    label: Text('Activ'),
    size: ColumnSize.S,
  ),

  /// Time Column definition
  const DataColumn2(label: Text('Editează'), fixedWidth: 100),
];
