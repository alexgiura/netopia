import 'package:erp_frontend_v2/models/document/document_generate_model.dart';
import 'package:erp_frontend_v2/widgets/custom_checkbox.dart';
import 'package:erp_frontend_v2/widgets/custom_data_table.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../constants/style.dart';
import '../../../../widgets/custom_text_field_double.dart';

class DocumentGenerateDataTable extends ConsumerStatefulWidget {
  const DocumentGenerateDataTable(
      {super.key, required this.data, required this.onSelect});
  final List<DocumentGenerate> data;
  final void Function(DocumentGenerate, bool) onSelect;

  @override
  ConsumerState<DocumentGenerateDataTable> createState() =>
      _DocumentGenerateDataTableState();
}

class _DocumentGenerateDataTableState
    extends ConsumerState<DocumentGenerateDataTable> {
  late List<bool> checkboxValues;
  bool _selectAll = false;
  List<DocumentGenerate> _selectedItems = [];

  @override
  void initState() {
    super.initState();
    // Initialize checkboxValues
    checkboxValues = List.generate(widget.data.length, (index) => false);
  }

  void _toggleSelectAll(bool? newValue) {
    setState(() {
      _selectAll = newValue!;
      for (int i = 0; i < checkboxValues.length; i++) {
        if (checkboxValues[i] != newValue) {
          checkboxValues[i] = newValue;
          widget.onSelect(widget.data[i], newValue);
        }
      }
    });
  }

  void selectOne(bool newValue, int index) {
    setState(() {
      // Update the individual checkbox value
      checkboxValues[index] = newValue;
      // Check if all checkboxes are selected
      _selectAll = checkboxValues.every((element) => element);

      // Call onSelect for the current row
      widget.onSelect(widget.data[index], newValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<DataColumn2> _columns = [
      DataColumn2(
        label: CustomCheckbox(
          value: _selectAll,
          onChanged:
              _toggleSelectAll, // Step 2: Use the _toggleSelectAll method
        ),
        fixedWidth: 60,
        // size: ColumnSize.S,
      ),
      const DataColumn2(
        label: Text('Număr Document'),
        size: ColumnSize.S,
      ),
      const DataColumn2(
        label: Text('Dată Document'),
        size: ColumnSize.S,
      ),
      const DataColumn2(
        label: Text('Denumire Produs'),
        size: ColumnSize.S,
      ),
      const DataColumn2(
        label: Text('Cantitate Disponibilă'),
        size: ColumnSize.S,
      ),
    ];

    return Container(
      //padding: const EdgeInsets.only(top: 16),
      decoration: CustomStyle.customContainerDecoration,
      child: CustomDataTable(columns: _columns, rows: getRows(widget.data)),
    );
  }

  List<DataRow2> getRows(List<DocumentGenerate> data) {
    //
    return data.asMap().entries.map((row) {
      int index = row.key;

      List<DataCell> cells = [
        DataCell(
          Align(
            alignment: Alignment.centerLeft,
            child: CustomCheckbox(
              value: checkboxValues[index],
              onChanged: (newValue) {
                selectOne(newValue, index);
                // // widget.onSelect(data[index], newValue);
                // setState(() {

                // });
              },
            ),
          ),
        ),
        DataCell(Text(row.value.number)),
        DataCell(Text(row.value.date)),
        DataCell(Text(row.value.documentItem.item.name)),
        DataCell(
          CustomTextFieldFloat(
            initialValue: row.value.documentItem.quantity,
            onValueChanged: (double value) {},
            readonly: true,
          ),
        ),
      ];

      return DataRow2(
        cells: cells,
      );
    }).toList();
  }

  //
}
