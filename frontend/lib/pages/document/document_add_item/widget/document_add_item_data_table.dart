import 'package:erp_frontend_v2/widgets/custom_data_table.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import '../../../../constants/style.dart';
import '../../../../models/document/document_model.dart';
import '../../../../models/item/item_model.dart';

class DocumentAddItemDataTable extends StatefulWidget {
  const DocumentAddItemDataTable(
      {super.key, required this.data, required this.onSave});
  final List<Item>? data;
  final void Function(DocumentItem) onSave;

  @override
  State<DocumentAddItemDataTable> createState() =>
      DocumentAddItemDataTableState();
}

class DocumentAddItemDataTableState extends State<DocumentAddItemDataTable> {
  int? selectedRowIndex;
  late DocumentItem _item = DocumentItem.empty();
  List<Item> _dataList = [];

  @override
  void initState() {
    super.initState();
    _dataList = widget.data!;
  }

  // void updateItemInDataTable(int index, Item modifiedItem) {
  //   setState(() {
  //     widget.data![index] = modifiedItem;
  //   });
  // }

  void updateList(List<Item> newDataList) {
    setState(() {
      _dataList = newDataList;
    });
  }

  String selectedHid = '';
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CustomDataTable(
            columns: _columns,
            rows: getRows(_dataList),
          ),
        ),
      ],
    );
  }

  List<DataRow2> getRows(List<Item> data) {
    return data.asMap().entries.map((row) {
      int index = row.key;
      Item item = row.value;

      return DataRow2(
        onTap: () {
          _item = DocumentItem(
            id: item.id!,
            code: item.code,
            name: item.name,
            um: item.um,
            vat: item.vat,
            quantity: 0.00,
            price: null,
            amountNet: null,
            amountVat: null,
            amountGross: null,
          );

          widget.onSave(_item);

          if (context.mounted) {
            Navigator.of(context).pop();
          }
        },
        onSelectChanged: (selected) {
          setState(() {});
        },
        cells: [
          DataCell(Text(row.value.name)),
          DataCell(Text(row.value.code ?? '')),
          DataCell(Text(row.value.um.name)),
          DataCell(
            Center(
              child: Checkbox(
                activeColor: CustomColor.active,
                value: row.value.isStock,
                onChanged: (newValue) {},
              ),
            ),
          ),
          DataCell(
            Center(
              child: Checkbox(
                activeColor: CustomColor.active,
                value: row.value.isActive,
                onChanged: (newValue) {},
              ),
            ),
          ),
        ],
      );
    }).toList();
  }
}

List<DataColumn2> _columns = [
  DataColumn2(
    label: Text('Denumire'),
    size: ColumnSize.L,
  ),
  DataColumn2(
    label: Text('Cod'),
    size: ColumnSize.S,
  ),
  DataColumn2(
    label: Text('UM'),
    size: ColumnSize.S,
  ),
  DataColumn2(
    label: Align(alignment: Alignment.center, child: Text('Stocabil')),
    size: ColumnSize.S,
  ),
  DataColumn2(
    label: Align(alignment: Alignment.center, child: Text('Activ')),
    size: ColumnSize.S,
  ),
];
