import 'package:erp_frontend_v2/models/partner/partner_model.dart';
import 'package:erp_frontend_v2/models/partner/partner_type_model.dart';
import 'package:erp_frontend_v2/models/static_model.dart';
import 'package:erp_frontend_v2/providers/partner_provider.dart';
import 'package:erp_frontend_v2/widgets/custom_checkbox.dart';
import 'package:erp_frontend_v2/widgets/custom_data_table.dart';
import 'package:erp_frontend_v2/widgets/custom_search_bar.dart';
import 'package:erp_frontend_v2/widgets/custom_tab_bar.dart';
import 'package:erp_frontend_v2/widgets/filters/drop_down_filter/drop_down_filter.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../constants/style.dart';

import '../partner_details_page.dart';

class PartnerPageDataTable extends ConsumerStatefulWidget {
  const PartnerPageDataTable({
    super.key,
  });
  // final List<Partner>? data;

  @override
  ConsumerState<PartnerPageDataTable> createState() =>
      _PartnerPageDataTableState();
}

class _PartnerPageDataTableState extends ConsumerState<PartnerPageDataTable>
    with SingleTickerProviderStateMixin {
  String selectedHid = '';
  late TabController _tabController;
  List<Partner> filteredData = [];
  // params
  String? _searchText;
  List<bool> _selectStatus = [];
  List<String> _selectedTypes = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _selectStatus.add(true);
    _tabController.addListener(() {
      int selectedIndex = _tabController.index;
      // Check if the index is already being processed
      if (_tabController.indexIsChanging) {
        return;
      }
      setState(() {
        _selectStatus.clear();
        switch (selectedIndex) {
          case 0:
            // 'Activi' tab is selected
            _selectStatus.add(true);
            break;
          case 1:
            // 'Inactiv' tab is selected
            _selectStatus.add(false);
            break;
          case 2:
            // 'All' tab is selected
            _selectStatus.add(true);
            _selectStatus.add(false);
            break;
        }
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // void updatePartnerInDataTable(int index, Partner modifiedPartner) {
  //   setState(() {
  //     widget.data![index] = modifiedPartner;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final partnerState = ref.watch(partnerProvider);
    // // Declare static variables
    // final StaticData activValue = StaticData(name: PartnerType.company.name);
    // final StaticData inactiveValue = StaticData(name: PartnerType.partnerTypes);
    return Container(
      padding: const EdgeInsets.only(top: 16),
      decoration: CustomStyle.customContainerDecoration,
      child: partnerState.when(
        skipLoadingOnReload: true,
        skipLoadingOnRefresh: true,
        data: (documentList) {
          // return Column(
          //   children: [
          //     Container(height: 100, width: 100, color: Colors.black),
          //   ],
          // );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CustomTabBar(
                  tabController: _tabController,
                  tabs: const [
                    Tab(text: 'Activi'),
                    Tab(text: 'Inactivi'),
                    Tab(text: 'Toti'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 4,
                      child: CustomSearchBar(
                        hintText: "Cauta dupa denumire, CUI/CNP",
                        initialValue: _searchText,
                        onValueChanged: (value) {
                          setState(() {
                            _searchText = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    DropDownFilter(
                        labelText: 'Tip partener',
                        enableSearch: false,
                        onValueChanged: (selectedList) {
                          setState(() {
                            _selectedTypes = selectedList
                                .map((partner) => partner.name)
                                .toList();
                          });
                        },
                        staticData: PartnerType.partnerTypes),
                    const SizedBox(
                      width: 8,
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.refresh_rounded,
                        color: CustomColor.active,
                      ),
                      onPressed: () {
                        // Handle refresh logic here
                        // _fetchDocuments();
                      },
                    ),
                    const Spacer(),
                    const Spacer(),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: CustomDataTable(
                  // showCheckbox: true,
                  columns: _columns,
                  rows: getRows(documentList),
                  // onSelectRows: (selectedRows) {
                  //   // List<Partner> selectedPartners =
                  //   //     selectedRows.map((index) => documentList[index]).toList();
                  // },
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
      ),
    );
  }

  List<DataRow2> getRows(List<Partner> data) {
    List<Partner> filteredData = data.where((row) {
      bool statusMatch =
          _selectStatus.isEmpty || _selectStatus.contains(row.isActive);

      bool typeMatch =
          _selectedTypes.isEmpty || _selectedTypes.contains(row.type);

      bool searchTextMatch = _searchText == null ||
          _searchText!.isEmpty ||
          row.name.toLowerCase().contains(_searchText!.toLowerCase()) ||
          (row.vatNumber?.toLowerCase() ?? '')
              .contains(_searchText!.toLowerCase());

      return statusMatch && typeMatch && searchTextMatch;
    }).toList();

    return filteredData.asMap().entries.map((row) {
      // int index = row.key;
      Partner partner = row.value; // Get the partner object for the current row

      return DataRow2(
        cells: [
          //DataCell(Text(row.value.code ?? '')),
          DataCell(Text(row.value.name)),
          DataCell(Text(row.value.type)),
          DataCell(Text(row.value.vatNumber ?? '')),
          DataCell(Text(row.value.registrationNumber ?? '')),
          DataCell(
            Chip(
              label: Text(row.value.isActive ? 'Activ' : 'Inactiv'),
              labelStyle: TextStyle(
                  color: row.value.isActive
                      ? CustomColor.active
                      : CustomColor.dark),
              backgroundColor: row.value.isActive
                  ? CustomColor.active.withOpacity(0.1)
                  : CustomColor.lightest,
            ),
          ),
          // DataCell(
          //   Checkbox(
          //     activeColor: CustomColor.active,
          //     value: row.value.isActive,
          //     onChanged: (newValue) {},
          //   ),
          // ),
          DataCell(
            IconButton(
              hoverColor: CustomColor.lightest,
              splashRadius: 22,
              icon: const Icon(Icons.edit_outlined, color: CustomColor.active),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return PartnerDetailsPopup(
                      partner: partner,
                      // onSave: (modifiedPartner) {
                      //   updatePartnerInDataTable(index, modifiedPartner);
                      // },
                    ); // Use the CustomPopup widget here
                  },
                );
              },
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
    label: Text('Tip'),
    size: ColumnSize.M,
  ),

  const DataColumn2(
    label: Text('CUI/CNP'),
    size: ColumnSize.M,
  ),

  const DataColumn2(
    label: Text('Nr.Reg.Com.'),
    size: ColumnSize.M,
  ),
  const DataColumn2(
    label: Text('Activ'),
    size: ColumnSize.S,
  ),

  /// Time Column definition
  const DataColumn2(label: Text('Editează'), fixedWidth: 100),
];
