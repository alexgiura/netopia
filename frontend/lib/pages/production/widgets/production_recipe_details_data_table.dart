import 'package:data_table_2/data_table_2.dart';
import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/models/document/document_model.dart';
import 'package:erp_frontend_v2/pages/document/document_add_item/document_add_item_popup.dart';
import 'package:erp_frontend_v2/widgets/custom_data_table.dart';
import 'package:erp_frontend_v2/widgets/custom_text_field_double.dart';
import 'package:flutter/material.dart';

class RecipeDetailsDataTable extends StatefulWidget {
  final List<DocumentItem>? data;
  final void Function(List<DocumentItem>) onUpdate;
  final String title;
  final String itemType;
  const RecipeDetailsDataTable(
      {super.key,
      required this.data,
      required this.onUpdate,
      required this.title,
      required this.itemType});

  @override
  State<RecipeDetailsDataTable> createState() => _RecipeDetailsDataTableState();
}

class _RecipeDetailsDataTableState extends State<RecipeDetailsDataTable> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
          padding: EdgeInsets.only(left: 16, right: 16, top: 16),
          decoration: CustomStyle.customContainerDecoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.title,
                    style: CustomStyle.subtitleText,
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 35,
                    child: ElevatedButton.icon(
                      style: CustomStyle.activeButton,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AddItemPopup(
                              onSave: (newItem) {
                                setState(() {
                                  newItem.itemTypePn = widget.itemType;
                                  widget.data!.add(newItem);
                                  widget.onUpdate(widget.data!);
                                });
                              },
                            );
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.add,
                        color: CustomColor.white,
                      ),
                      label: const Text(
                        'Adauga',
                        style: CustomStyle.primaryButtonText,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: CustomDataTable(
                    columns: _columns, rows: getRows(widget.data!)),
              ),
            ],
          )),
    );
  }

  List<DataRow2> getRows(List<DocumentItem> data) {
    return data
        .where((item) => item.itemTypePn == widget.itemType)
        .toList()
        .asMap()
        .entries
        .map((row) {
      int originalIndex = data.indexOf(row.value);

      List<DataCell> cells = [
        DataCell(Text(row.value.name)),
        DataCell(
          CustomTextFieldFloat(
            maxDecimalNumber: 3,
            initialValue: row.value.quantity,
            onValueChanged: (double value) {
              data[originalIndex].quantity = value;
              widget.onUpdate(data);
            },
            // readonly: widget.readOnly,
          ),
        ),
        DataCell(Text(row.value.um.name)),
        DataCell(
          IconButton(
            hoverColor: CustomColor.lightest,
            splashRadius: 22,
            icon: const Icon(Icons.delete_outlined, color: Colors.red),
            onPressed: () {
              setState(() {
                data.remove(row.value);
                widget.onUpdate(data);
              });
            },
          ),
        ),
      ];

      return DataRow2(
        cells: cells,
      );
    }).toList();
  }
}

final List<DataColumn2> _columns = [
  const DataColumn2(
    label: Text('Denumire'),
    size: ColumnSize.L,
  ),
  const DataColumn2(
    label: Text('Cantitate'),
    size: ColumnSize.L,
  ),
  const DataColumn2(
    label: Text('UM'),
    size: ColumnSize.L,
  ),
  const DataColumn2(
    label: Text('Actiuni'),
    fixedWidth: 100,
  ),
];
