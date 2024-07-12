import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/providers/partner_provider.dart';
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

class DocumentItemsDataTable extends ConsumerStatefulWidget {
  const DocumentItemsDataTable({
    super.key,
    required this.data,
    required this.onUpdate,
    required this.documentTypeId,
    this.readOnly,
  });
  final List<DocumentItem>? data;

  final bool? readOnly;
  final void Function(List<DocumentItem>) onUpdate;

  final int documentTypeId;

  @override
  ConsumerState<DocumentItemsDataTable> createState() =>
      _DocumentItemsDataTableState();
}

class _DocumentItemsDataTableState
    extends ConsumerState<DocumentItemsDataTable> {
  void updateDocumentItemAmount(int index) {
    setState(() {
      widget.data![index].amountNet =
          widget.data![index].quantity * widget.data![index].price!;

      widget.data![index].amountVat = widget.data![index].amountNet! *
          widget.data![index].item.vat.percent /
          100;

      widget.data![index].amountGross =
          widget.data![index].amountNet! + widget.data![index].amountVat!;
    });
  }

  void updateDocumentItemPrice(int index) {
    setState(() {
      widget.data![index].amountNet = (widget.data![index].amountGross! * 100) /
          (100 + widget.data![index].item.vat.percent);

      widget.data![index].amountVat =
          widget.data![index].amountGross! - widget.data![index].amountNet!;

      widget.data![index].price =
          widget.data![index].amountNet! / widget.data![index].quantity;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: CustomStyle.customContainerDecoration(),
      child:
          CustomDataTable(columns: getColumns(), rows: getRows(widget.data!)),
    );
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
      if ([1, 2].contains(widget.documentTypeId)) ...[
        DataColumn2(
            label: Text(
              'unit_price'.tr(context),
              style: CustomStyle.semibold16(color: CustomColor.greenGray),
            ),
            size: ColumnSize.S,
            numeric: true),
        DataColumn2(
            label: Container(
              alignment: Alignment.centerRight,
              child: Text(
                'vat_rate'.tr(context),
                style: CustomStyle.semibold16(color: CustomColor.greenGray),
              ),
            ),
            size: ColumnSize.S,
            numeric: true),
        DataColumn2(
            label: Text(
              'net_value'.tr(context),
              style: CustomStyle.semibold16(color: CustomColor.greenGray),
            ),
            size: ColumnSize.S,
            numeric: true),
        DataColumn2(
            label: Text(
              'vat_value'.tr(context),
              style: CustomStyle.semibold16(color: CustomColor.greenGray),
            ),
            size: ColumnSize.S,
            numeric: true),
        DataColumn2(
            label: Text(
              'gross_value'.tr(context),
              style: CustomStyle.semibold16(color: CustomColor.greenGray),
            ),
            size: ColumnSize.S,
            numeric: true),
      ],
      DataColumn2(
        label: Visibility(
          visible: widget.readOnly != true,
          child: Row(
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
        ),
        size: ColumnSize.S,
      ),
    ];

    return _columns;
  }

  List<DataRow2> getRows(List<DocumentItem> data) {
    double sumNet = data.fold(0.0, (sum, item) => sum + (item.amountNet ?? 0));
    double sumVat = data.fold(0.0, (sum, item) => sum + (item.amountVat ?? 0));
    double sumGross =
        data.fold(0.0, (sum, item) => sum + (item.amountGross ?? 0));
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
              updateDocumentItemAmount(index);
              widget.onUpdate(data);
            },
            readonly: widget.readOnly,
          ),
        ),
        DataCell(Container(
            alignment: Alignment.centerRight,
            child: Text(documentItem.item.um.name,
                style: CustomStyle.semibold14()))),
        if ([1, 2].contains(widget.documentTypeId)) ...[
          DataCell(
            CustomTextFieldFloat(
              initialValue:
                  documentItem.price != null ? documentItem.price! : 0.00,
              onValueChanged: (double value) {
                data[index].price = value;
                updateDocumentItemAmount(index);
                widget.onUpdate(data);
              },
              readonly: widget.readOnly,
            ),
          ),
          DataCell(Container(
              alignment: Alignment.centerRight,
              child: Text(documentItem.item.vat.name,
                  style: CustomStyle.semibold14()))),
          DataCell(Container(
              alignment: Alignment.centerRight,
              child: Text(
                  documentItem.amountNet != null
                      ? documentItem.amountNet.toString()
                      : '0.00',
                  style: CustomStyle.semibold14()))),
          DataCell(Container(
              alignment: Alignment.centerRight,
              child: Text(
                  documentItem.amountVat != null
                      ? documentItem.amountVat.toString()
                      : '0.00',
                  style: CustomStyle.semibold14()))),
          DataCell(Container(
              alignment: Alignment.centerRight,
              child: Text(
                  documentItem.amountGross != null
                      ? documentItem.amountGross.toString()
                      : '0.00',
                  style: CustomStyle.semibold14()))),
        ],
        DataCell(
          Visibility(
            visible: widget.readOnly != true,
            child: Row(
              children: [
                Spacer(),
                Container(
                  width: 52,
                  alignment: Alignment.center, // Keep data cell centered
                  child: IconButton(
                    hoverColor: CustomColor.lightest,
                    splashRadius: 22,
                    icon: const Icon(Icons.delete_outline_rounded,
                        color: CustomColor.error),
                    onPressed: () {
                      setState(() {
                        widget.data!.remove(data[index]);
                        widget.onUpdate(data);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ];

      return DataRow2(
        cells: cells,
      );
    }).toList();

    // Add subtotal row
    if ([1, 2].contains(widget.documentTypeId)) {
      DataRow2 subtotalRow = DataRow2(cells: [
        DataCell(Text('')),
        DataCell(Text('')),
        DataCell(Text('')),
        DataCell(Text('')),
        DataCell(Text('')),
        DataCell(Container(
          alignment: Alignment.bottomRight,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('subtotal'.tr(context),
                  style: CustomStyle.semibold16(color: CustomColor.greenGray)),
              Gap(4),
              Text('${sumNet.toStringAsFixed(2)} RON',
                  style: CustomStyle.semibold14()),
            ],
          ),
        )),
        DataCell(Container(
          alignment: Alignment.bottomRight,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('total_vat'.tr(context),
                  style: CustomStyle.semibold16(color: CustomColor.greenGray)),
              Gap(4),
              Text('${sumVat.toStringAsFixed(2)} RON',
                  style: CustomStyle.semibold14()),
            ],
          ),
        )),
        DataCell(Container(
          alignment: Alignment.centerRight,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('total'.tr(context), style: CustomStyle.bold16()),
              Gap(4),
              Text('${sumGross.toStringAsFixed(2)} RON',
                  style: CustomStyle.semibold14()),
            ],
          ),
        )),
        DataCell(Text('')),
      ]);

      rows.add(subtotalRow);
    }

    return rows;
  }
}
