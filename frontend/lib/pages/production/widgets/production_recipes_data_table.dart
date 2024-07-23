import 'package:erp_frontend_v2/models/recipe/recipe_model.dart';
import 'package:erp_frontend_v2/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:go_router/go_router.dart';
import '../../../constants/style.dart';

class ProductionRecipesDataTable extends StatefulWidget {
  const ProductionRecipesDataTable(
      {super.key, required this.data, this.refreshCallback});
  final List<Recipe>? data;
  final void Function()? refreshCallback;

  @override
  State<ProductionRecipesDataTable> createState() =>
      _ProductionRecipesDataTableState();
}

class _ProductionRecipesDataTableState
    extends State<ProductionRecipesDataTable> {
  void updateItemInDataTable(int index, Recipe modifiedItem) {
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
                  borderRadius: CustomStyle.containerDefaultCustomBorderRadius,
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

  List<DataRow2> getRows(List<Recipe> data) {
    return data.asMap().entries.map((row) {
      int index = row.key;
      Recipe itemCategory = row.value; //
      return DataRow2(
        cells: [
          DataCell(Text(row.value.name)),
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
                  context.goNamed(productionRecipeDetailsPageName,
                      pathParameters: {
                        'id1': row.value.id.toString(),
                      },
                      extra: widget.refreshCallback);
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
    label: Text('Denumire Reteta'),
    size: ColumnSize.L,
  ),

  const DataColumn2(
    label: Center(child: Text('Activ')),
    size: ColumnSize.L,
  ),

  /// Time Column definition
  const DataColumn2(label: Center(child: Text('Editeaza')), fixedWidth: 100),
];
