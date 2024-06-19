import 'package:erp_frontend_v2/models/item/item_category_model.dart';
import 'package:erp_frontend_v2/pages/item/widgets/item_category_popup.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import '../../../constants/style.dart';

class ItemCategoryPageDataTable extends StatefulWidget {
  const ItemCategoryPageDataTable({super.key, required this.data});
  final List<ItemCategory>? data;

  @override
  State<ItemCategoryPageDataTable> createState() =>
      _ItemCategoryPageDataTableState();
}

class _ItemCategoryPageDataTableState extends State<ItemCategoryPageDataTable> {
  void updateItemInDataTable(int index, ItemCategory modifiedItem) {
    setState(() {
      widget.data![index] = modifiedItem;
    });
  }

  String selectedHid = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      decoration: CustomStyle.customContainerDecoration(),
      child: Column(
        children: [
          Expanded(
            child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: CustomColor.lightest,
                // Customize the color of the separator
              ),
              child: SelectionArea(
                child: ClipRRect(
                  borderRadius: CustomStyle.customBorderRadius,
                  child: DataTable2(
                      // hover row color
                      dataRowColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.hovered)) {
                          return CustomColor.active.withOpacity(0.1);
                        }

                        return null; // Use the default value.
                      }),
                      dataTextStyle: CustomStyle.bodyText,
                      headingTextStyle: CustomStyle.tableHeaderText,
                      headingRowColor:
                          const MaterialStatePropertyAll(CustomColor.lightest),
                      showCheckboxColumn: false,
                      dividerThickness: 1.0,
                      dataRowHeight: 54,
                      headingRowHeight: 54,
                      horizontalMargin: 16,
                      columnSpacing: 12,
                      columns: _columns,
                      rows: getRows(widget.data!)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<DataRow2> getRows(List<ItemCategory> data) {
    return data.asMap().entries.map((row) {
      int index = row.key;
      ItemCategory itemCategory = row.value; //
      return DataRow2(
        cells: [
          DataCell(Text(row.value.name)),
          DataCell(
            Center(
              child: Checkbox(
                activeColor: CustomColor.active,
                value: row.value.generatePn,
                onChanged: (newValue) {
                  // For read-only purposes, you can omit this onChanged callback.
                },
              ),
            ),
          ),
          DataCell(
            Center(
              child: Checkbox(
                activeColor: CustomColor.active,
                value: row.value.isActive,
                onChanged: (newValue) {
                  // For read-only purposes, you can omit this onChanged callback.
                },
              ),
            ),
          ),
          DataCell(
            Center(
              child: IconButton(
                hoverColor: CustomColor.lightest,
                splashRadius: 22,
                icon: const Icon(Icons.edit_outlined,
                    color: CustomColor
                        .active), // Replace with your desired edit icon
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ItemCategoryDetailsPopup(
                        itemCategory: itemCategory,
                        onSave: (modifiedItemCategory) {
                          updateItemInDataTable(index, modifiedItemCategory);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
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
    label: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Produs Finit'),
        SizedBox(width: 4), // Add some spacing between text and icon
        Tooltip(
          message: 'Se va genera automat raport de productie',
          child: Icon(
            Icons.info_rounded,
            size: 20,
            color: CustomColor.light, // Adjust the size of the icon as needed
          ),
        ),
      ],
    ),
    size: ColumnSize.L,
  ),
  const DataColumn2(
    label: Center(child: Text('Activ')),
    size: ColumnSize.L,
  ),

  /// Time Column definition
  const DataColumn2(label: Center(child: Text('Editeaza')), fixedWidth: 100),
];
