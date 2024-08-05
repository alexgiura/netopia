import 'package:data_table_2/data_table_2.dart';
import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/models/report/item_stock_report_model.dart';
import 'package:erp_frontend_v2/providers/dashboard_provider.dart';
import 'package:erp_frontend_v2/widgets/custom_data_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ItemStockChart extends ConsumerStatefulWidget {
  const ItemStockChart({super.key, this.title});
  // final List<ItemStockReport>? data;
  final String? title;

  @override
  ConsumerState<ItemStockChart> createState() => _ItemStockChartState();
}

class _ItemStockChartState extends ConsumerState<ItemStockChart> {
  @override
  Widget build(BuildContext context) {
    final itemList = ref.watch(itemStockChartProvider);

    return itemList.when(
      data: (data) {
        return Container(
          padding: const EdgeInsets.all(0),
          decoration: CustomStyle.customContainerDecoration(),
          child: Column(
            children: [
              Row(
                children: [
                  const SizedBox(width: 16),
                  if (widget.title != null)
                    Column(
                      children: [
                        Text(
                          widget.title!,
                          style: CustomStyle.semibold16(
                              color: CustomColor.greenGray),
                        ),
                        const SizedBox(height: 16),
                      ],
                    )
                ],
              ),
              Expanded(
                child: CustomDataTable(
                  columns: _columns,
                  rows: getRows(data),
                ),
              )
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Text(e.toString()),
    );
  }

  List<DataRow2> getRows(List<ItemStockReport> data) {
    return data.asMap().entries.map((row) {
      return DataRow2(
        cells: [
          DataCell(Text(
            row.value.itemCode!,
            style: CustomStyle.semibold14(color: CustomColor.textPrimary),
          )),
          DataCell(Text(row.value.itemName,
              style: CustomStyle.semibold14(color: CustomColor.textPrimary))),
          DataCell(Text(row.value.itemQuantity.toStringAsFixed(2),
              style: CustomStyle.semibold14(color: CustomColor.textPrimary))),
          DataCell(Text(row.value.itemUm!,
              style: CustomStyle.semibold14(color: CustomColor.textPrimary))),
          DataCell(Text("${row.value.total ?? 0.00.toStringAsFixed(2)} RON",
              style: CustomStyle.semibold14(color: CustomColor.textPrimary))),
        ],
      );
    }).toList();
  }
}

List<DataColumn2> _columns = [
  DataColumn2(
    label: Text(
      'Cod',
      style: CustomStyle.semibold16(color: CustomColor.greenGray),
    ),
    size: ColumnSize.S,
  ),
  DataColumn2(
    label: Text('Denumire',
        style: CustomStyle.semibold16(color: CustomColor.greenGray)),
    size: ColumnSize.L,
  ),
  DataColumn2(
    label: Text('Cantitate',
        style: CustomStyle.semibold16(color: CustomColor.greenGray)),
    size: ColumnSize.S,
  ),
  DataColumn2(
    label:
        Text('UM', style: CustomStyle.semibold16(color: CustomColor.greenGray)),
    size: ColumnSize.S,
  ),
  DataColumn2(
    label: Text('Sumă totală',
        style: CustomStyle.semibold16(color: CustomColor.greenGray)),
    size: ColumnSize.S,
  ),
];
