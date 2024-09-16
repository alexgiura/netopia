import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/models/department_model.dart';
import 'package:erp_frontend_v2/pages/item/widgets/item_unit_popup.dart';

import 'package:erp_frontend_v2/providers/department_provider.dart';
import 'package:erp_frontend_v2/widgets/buttons/edit_button.dart';
import 'package:erp_frontend_v2/widgets/custom_activ_status.dart';
import 'package:erp_frontend_v2/widgets/custom_data_table.dart';
import 'package:erp_frontend_v2/widgets/custom_search_bar.dart';
import 'package:erp_frontend_v2/widgets/custom_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../constants/style.dart';

class DepartmentsDataTable extends ConsumerStatefulWidget {
  const DepartmentsDataTable({
    super.key,
  });

  @override
  ConsumerState<DepartmentsDataTable> createState() =>
      _DepartmentsDataTableState();
}

class _DepartmentsDataTableState extends ConsumerState<DepartmentsDataTable>
    with SingleTickerProviderStateMixin, RouteAware {
  final GlobalKey<CustomDataTableState> _customDataTableKey =
      GlobalKey<CustomDataTableState>();
  String selectedHid = '';
  String? _searchText;

  List<bool> _selectStatus = [];

  @override
  void initState() {
    super.initState();
  }

  void _allItems() {
    setState(() {
      _selectStatus.add(true);
      _selectStatus.add(false);
    });
  }

  void _activeItems() {
    setState(() {
      _selectStatus.clear();
      _selectStatus.add(true);
    });
  }

  void _inactiveItems() {
    setState(() {
      _selectStatus.clear();
      _selectStatus.clear();
      _selectStatus.add(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final itemUnitsState = ref.watch(departmentsProvider);

    final List<DataColumn2> _columns = [
      DataColumn2(
        label: Text(
          'code'.tr(context),
          style: CustomStyle.semibold16(color: CustomColor.greenGray),
        ),
        size: ColumnSize.L,
      ),
      DataColumn2(
        label: Text(
          'name'.tr(context),
          style: CustomStyle.semibold16(color: CustomColor.greenGray),
        ),
        size: ColumnSize.L,
      ),
      DataColumn2(
          label: Container(
              alignment: Alignment.center,
              child: Text(
                'active'.tr(context),
                style: CustomStyle.semibold16(color: CustomColor.greenGray),
              )),
          size: ColumnSize.M),
      DataColumn2(
          label: Container(
              alignment: Alignment.center,
              child: Text(
                'details'.tr(context),
                style: CustomStyle.semibold16(color: CustomColor.greenGray),
              )),
          fixedWidth: 60),
    ];

    return itemUnitsState.when(
      skipLoadingOnReload: true,
      skipLoadingOnRefresh: true,
      data: (departmentList) {
        return Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: CustomStyle.customContainerDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTabBar(
                    tabs: [
                      Text('valid_feminin'.tr(context)),
                      Text('canceled'.tr(context)),
                      Text('all_feminin'.tr(context)),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectStatus.clear();
                        switch (value) {
                          case 0:
                            // 'Activi' tab is selected
                            _activeItems();
                            break;
                          case 1:
                            // 'Inactiv' tab is selected
                            _inactiveItems();
                            break;
                          case 2:
                            // 'All' tab is selected
                            _allItems();
                            break;
                        }
                      });
                    },
                  ),
                  const Gap(24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 4,
                        child: CustomSearchBar(
                          hintText: 'document_hint_search'.tr(context),
                          initialValue: _searchText,
                          onValueChanged: (value) {
                            setState(() {
                              _searchText = value;
                            });
                          },
                        ),
                      ),
                      const Gap(8),

                      const Spacer(),
                      // const SelectColumns()
                    ],
                  ),
                  const Gap(24),
                  Flexible(
                    child: CustomDataTable(
                      key: _customDataTableKey,
                      columns: getColumns(context),
                      rows: getRows(departmentList),
                      // columns: _columns,
                      // rows: getRows(departmentList),
                    ),
                  ),
                ],
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
    );
  }

  List<DataRow2> getRows(List<Department> data) {
    List<Department> filteredData = data.where((row) {
      bool statusMatch =
          _selectStatus.isEmpty || _selectStatus.contains(!(row.flags == 2));

      bool searchTextMatch = _searchText == null ||
          _searchText!.isEmpty ||
          (row.name.toLowerCase()).contains(_searchText!.toLowerCase());
      return statusMatch && searchTextMatch;
    }).toList();

    return filteredData.asMap().entries.map((row) {
      Department department = row.value;
      return DataRow2(
        cells: [
          DataCell(
            Text(
              department.id.toString(),
              style: CustomStyle.semibold14(),
            ),
          ),
          DataCell(Text(
            department.name,
            style: CustomStyle.semibold14(),
          )),
          DataCell(Container(
            alignment: Alignment.center,
            child: CustomActiveStatus(
              isActive: department.flags == 1,
            ),
          )),
          DataCell(Container(
            alignment: Alignment.center,
            child: CustomEditButton(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DepartmentPopup(
                      department: department,
                    );
                  },
                );
              },
            ),
          )),
        ],
      );
    }).toList();
  }

  // List<DataRow2> getRows(List<Department> departmentList) => departmentList
  //     .map((Department department) => DataRow2(
  //           cells: [
  //             DataCell(
  //               Text(
  //                 department.id.toString(),
  //                 style: CustomStyle.semibold14(),
  //               ),
  //             ),
  //             DataCell(Text(
  //               department.name,
  //               style: CustomStyle.semibold14(),
  //             )),
  //             DataCell(Container(
  //               alignment: Alignment.center,
  //               child: CustomActiveStatus(
  //                 isActive: department.flags == 1,
  //               ),
  //             )),
  //             DataCell(Container(
  //               alignment: Alignment.center,
  //               child: CustomEditButton(
  //                 onTap: () {
  //                   showDialog(
  //                     context: context,
  //                     builder: (BuildContext context) {
  //                       return DepartmentPopup(
  //                         department: department,
  //                       );
  //                     },
  //                   );
  //                 },
  //               ),
  //             )),
  //           ],
  //         ))
  //     .toList();

  List<DataColumn2> getColumns(BuildContext context) {
    return [
      DataColumn2(
        label: Text(
          'code'.tr(context),
          style: CustomStyle.semibold16(color: CustomColor.greenGray),
        ),
        size: ColumnSize.L,
      ),
      DataColumn2(
        label: Text(
          'name'.tr(context),
          style: CustomStyle.semibold16(color: CustomColor.greenGray),
        ),
        size: ColumnSize.L,
      ),
      DataColumn2(
          label: Container(
              alignment: Alignment.center,
              child: Text(
                'active'.tr(context),
                style: CustomStyle.semibold16(color: CustomColor.greenGray),
              )),
          size: ColumnSize.M),
      DataColumn2(
          label: Container(
              alignment: Alignment.center,
              child: Text(
                'details'.tr(context),
                style: CustomStyle.semibold16(color: CustomColor.greenGray),
              )),
          fixedWidth: 60),
    ];
  }
}
