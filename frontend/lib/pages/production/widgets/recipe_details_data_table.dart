import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/providers/partner_provider.dart';
import 'package:erp_frontend_v2/utils/util_functions.dart';
import 'package:erp_frontend_v2/widgets/custom_data_table.dart';
import 'package:erp_frontend_v2/widgets/not_used_widgets/custom_document_drop_down.dart';
import 'package:erp_frontend_v2/widgets/not_used_widgets/custom_search_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../../constants/style.dart';
import '../../../../models/document/document_model.dart';
import '../../../../widgets/custom_text_field_double.dart';

class RecipeItemsDataTable extends ConsumerStatefulWidget {
  const RecipeItemsDataTable({
    super.key,
    required this.data,
    required this.onUpdate,
    this.readOnly,
  });
  final List<DocumentItem>? data;

  final bool? readOnly;
  final void Function(List<DocumentItem>) onUpdate;

  @override
  ConsumerState<RecipeItemsDataTable> createState() =>
      _RecipeItemsDataTableState();
}

class _RecipeItemsDataTableState extends ConsumerState<RecipeItemsDataTable> {
  @override
  Widget build(BuildContext context) {
    return widget.data!.isNotEmpty
        ? CustomDataTable(columns: getColumns(), rows: getRows(widget.data!))
        : Container();
  }

  List<DataColumn2> getColumns() {
    List<DataColumn2> _columns = [
      DataColumn2(
        label: Text(
          'name'.tr(context),
          style: CustomStyle.semibold16(color: CustomColor.greenGray),
        ),
        size: ColumnSize.L,
      ),
      DataColumn2(
          label: Text(
            'quantity'.tr(context),
            style: CustomStyle.semibold16(color: CustomColor.greenGray),
          ),
          size: ColumnSize.S,
          numeric: true),
      DataColumn2(
        label: Container(
          alignment: Alignment.centerRight,
          child: Text(
            'um'.tr(context),
            style: CustomStyle.semibold16(color: CustomColor.greenGray),
          ),
        ),
        size: ColumnSize.S,
      ),
      if (widget.readOnly != true)
        DataColumn2(
          label: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Spacer(),
              Container(
                width: 52,
                alignment: Alignment.centerRight, // Align header to the right
                child: Text(
                  'Sterge',
                  style: CustomStyle.semibold16(color: CustomColor.greenGray),
                ),
              ),
            ],
          ),
          size: ColumnSize.S,
        ),
    ];

    return _columns;
  }

  List<DataRow2> getRows(List<DocumentItem> data) {
    List<DataRow2> rows = data.asMap().entries.map((row) {
      int index = row.key;
      DocumentItem documentItem = row.value;
      List<DataCell> cells = [
        DataCell(Text(documentItem.item.name, style: CustomStyle.semibold14())),
        DataCell(
          CustomTextFieldFloat(
            initialValue: documentItem.quantity,
            onValueChanged: (double value) {
              data[index].quantity = value;

              widget.onUpdate(data);
            },
            readonly: widget.readOnly,
          ),
        ),
        DataCell(Container(
            alignment: Alignment.centerRight,
            child: Text(documentItem.item.um.name,
                style: CustomStyle.semibold14()))),
        if (widget.readOnly != true)
          DataCell(
            Row(
              children: [
                Spacer(),
                Container(
                  width: 52,
                  alignment: Alignment.center,
                  child: IconButton(
                    hoverColor: CustomColor.lightest,
                    splashRadius: 22,
                    icon: const Icon(Icons.delete_outline_rounded,
                        color: CustomColor.error),
                    onPressed: () {
                      setState(() {
                        widget.data!.remove(data[index]);
                      });
                      widget.onUpdate(data);
                    },
                  ),
                ),
              ],
            ),
          ),
      ];

      return DataRow2(
        cells: cells,
      );
    }).toList();

    return rows;
  }
}
