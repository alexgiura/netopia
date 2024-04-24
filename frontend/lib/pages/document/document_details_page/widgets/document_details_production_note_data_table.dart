import 'package:erp_frontend_v2/models/partner/partner_model.dart';
import 'package:erp_frontend_v2/pages/document/document_generate_popup/document_generate_popup.dart';
import 'package:erp_frontend_v2/providers/document_transaction_provider.dart';
import 'package:erp_frontend_v2/providers/partner_provider.dart';
import 'package:erp_frontend_v2/providers/recipe_provider.dart';
import 'package:erp_frontend_v2/widgets/custom_dropdown.dart';
import 'package:erp_frontend_v2/widgets/custom_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../constants/style.dart';
import '../../../../models/document/document_model.dart';
import '../../../../widgets/custom_text_field_double.dart';

class DocumentItemsProductionNote extends ConsumerStatefulWidget {
  const DocumentItemsProductionNote({
    super.key,
    required this.data,
    required this.documentTypeId,
    required this.onUpdate,
    required this.partner,
    required this.date,
    this.readOnly,
  });
  final List<DocumentItem>? data;
  final bool? readOnly;
  final int documentTypeId;
  final void Function(List<DocumentItem>) onUpdate;
  final Partner partner;
  final String date;

  @override
  ConsumerState<DocumentItemsProductionNote> createState() =>
      _DocumentItemsNoPriceDataTableState();
}

class _DocumentItemsNoPriceDataTableState
    extends ConsumerState<DocumentItemsProductionNote>
    with TickerProviderStateMixin {
  late TabController _finalProductTabController;
  late TabController _rawMaterialTabController;
  int _selectedFinalProductTab = 0;
  int _selectedRawMaterialTab = 0;

  @override
  void initState() {
    super.initState();

    _finalProductTabController = TabController(vsync: this, length: 1);
    _rawMaterialTabController = TabController(vsync: this, length: 2);

    _finalProductTabController.addListener(() {
      if (!_finalProductTabController.indexIsChanging) {
        setState(() {
          _selectedFinalProductTab = _finalProductTabController.index;
        });
      }
    });

    _rawMaterialTabController.addListener(() {
      if (!_rawMaterialTabController.indexIsChanging) {
        setState(() {
          _selectedRawMaterialTab = _rawMaterialTabController.index;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.only(top: 16),
      decoration: CustomStyle.customContainerDecoration,
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 16),
              Expanded(
                child: Consumer(
                  builder: (context, watch, _) {
                    final recipes = ref.refresh(recipeProvider).value ?? [];

                    return CustomDropdown(
                      //key: formKey1,
                      //labelText: 'Partener',
                      hintText: 'Alege Reteta',
                      //initialValue: _document.partner,
                      onValueChanged: (value) {
                        setState(() {
                          if (widget.data != null) {
                            widget.data!.clear();
                          }
                          value.documentItems?.forEach((item) {
                            widget.data!.add(item);
                          });

                          widget.onUpdate(widget.data!);
                        });
                      },
                      dataList: recipes,
                      //enabled: widget.hId == '0',
                      errorText: "Camp obligatoriu",
                    );
                  },
                ),
              ),
              SizedBox(
                width: width / 64,
              ),
              const Spacer(),
              const SizedBox(width: 16),
            ],
          ),
          const SizedBox(height: 16),
          CustomTabBar(
            tabController: _finalProductTabController,
            tabs: const [
              Tab(text: 'Produs Finit'),
            ],
          ),
          Expanded(
            child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: CustomColor.lightest,
                // Customize the color of the separator
              ),
              child: SelectionArea(
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
                  rows: getRows(widget.data!
                      .where((item) => item.itemTypePn == 'finalProduct')
                      .toList()),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          CustomTabBar(
            tabController: _rawMaterialTabController,
            tabs: const [
              Tab(text: 'Materie Prima'),
              Tab(text: 'Manopera'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _rawMaterialTabController,
              children: <Widget>[
                // DataTable for "Materie prima"
                Container(
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: CustomColor.lightest,
                      // Customize the color of the separator
                    ),
                    child: SelectionArea(
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
                        headingRowColor: const MaterialStatePropertyAll(
                            CustomColor.lightest),
                        showCheckboxColumn: false,
                        dividerThickness: 1.0,
                        dataRowHeight: 54,
                        headingRowHeight: 54,
                        horizontalMargin: 16,
                        columnSpacing: 12,
                        columns: _columns,
                        rows: getRows(widget.data!
                            .where((item) => item.itemTypePn == 'rawMaterial')
                            .toList()),
                      ),
                    ),
                  ),
                ),
                // DataTable for "Manopera"
                Container(
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: CustomColor.lightest,
                      // Customize the color of the separator
                    ),
                    child: SelectionArea(
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
                        headingRowColor: const MaterialStatePropertyAll(
                            CustomColor.lightest),
                        showCheckboxColumn: false,
                        dividerThickness: 1.0,
                        dataRowHeight: 54,
                        headingRowHeight: 54,
                        horizontalMargin: 16,
                        columnSpacing: 12,
                        columns: _columns,
                        rows: getRows(widget.data!
                            .where((item) => item.itemTypePn == 'labour')
                            .toList()),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Dispose of the TabControllers to prevent memory leaks
    _finalProductTabController.dispose();
    _rawMaterialTabController.dispose();
    super.dispose();
  }

  //

  List<DataRow2> getRows(List<DocumentItem> data) {
    return data.asMap().entries.map((row) {
      int index = row.key;

      List<DataCell> cells = [
        // DataCell(Text(row.value.code ?? '')),
        DataCell(Text(row.value.name)),
        DataCell(
          CustomTextFieldFloat(
            initialValue: row.value.quantity,
            onValueChanged: (double value) {
              data[index].quantity = value;
              widget.onUpdate(data);
            },
            readonly: widget.readOnly,
          ),
        ),
        DataCell(Text(row.value.um.name)),
      ];

      return DataRow2(
        cells: cells,
      );
    }).toList();
  }

  //

  final List<DataColumn2> _columns = [
    // const DataColumn2(
    //   label: Text('Cod'),
    //   size: ColumnSize.L,
    // ),
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
    // const DataColumn2(
    //   label: Text('Actions'),
    //   fixedWidth: 100,
    // ),
  ];
}
