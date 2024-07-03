import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/models/partner/partner_model.dart';
import 'package:erp_frontend_v2/models/partner/partner_type_model.dart';
import 'package:erp_frontend_v2/models/static_model.dart';
import 'package:erp_frontend_v2/pages/partner/partner_details_page.dart';
import 'package:erp_frontend_v2/providers/partner_provider.dart';
import 'package:erp_frontend_v2/widgets/buttons/edit_button.dart';
import 'package:erp_frontend_v2/widgets/custom_activ_status.dart';
import 'package:erp_frontend_v2/widgets/custom_checkbox.dart';
import 'package:erp_frontend_v2/widgets/custom_data_table.dart';
import 'package:erp_frontend_v2/widgets/custom_search_bar.dart';
import 'package:erp_frontend_v2/widgets/custom_tab_bar.dart';
import 'package:erp_frontend_v2/widgets/filters/drop_down_filter/drop_down_filter.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../../../constants/style.dart';

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

  @override
  Widget build(BuildContext context) {
    final partnerState = ref.watch(partnerProvider);

    return partnerState.when(
      skipLoadingOnReload: true,
      skipLoadingOnRefresh: true,
      data: (documentList) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: CustomStyle.customContainerDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTabBar(
                tabController: _tabController,
                tabs: const [
                  Tab(text: 'Activi'),
                  Tab(text: 'Inactivi'),
                  Tab(text: 'Toti'),
                ],
              ),
              const Gap(24),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 4,
                    child: CustomSearchBar(
                      hintText: 'partner_hint_search'.tr(context),
                      initialValue: _searchText,
                      onValueChanged: (value) {
                        setState(() {
                          _searchText = value;
                        });
                      },
                    ),
                  ),
                  const Gap(8),
                  DropDownFilter(
                      labelText: 'partner_type'.tr(context),
                      enableSearch: false,
                      onValueChanged: (selectedList) {
                        setState(() {
                          _selectedTypes = selectedList
                              .map((partnerType) => partnerType.name)
                              .toList();
                        });
                      },
                      staticData: PartnerType.partnerTypes),
                  IconButton(
                    icon: const Icon(
                      Icons.refresh_rounded,
                      color: CustomColor.textPrimary,
                    ),
                    onPressed: () {
                      ref.read(partnerProvider.notifier).refreshPartners();
                    },
                  ),
                  const Spacer(),
                  const Spacer(),
                ],
              ),
              const Gap(24),
              Flexible(
                child: CustomDataTable(
                  columns: getColumns(context),
                  rows: getRows(documentList),
                ),
              ),
            ],
          ),
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
      Partner partner = row.value;

      return DataRow2(
        cells: [
          DataCell(Text(partner.name, style: CustomStyle.semibold14())),
          DataCell(
              Text(partner.type.toString(), style: CustomStyle.semibold14())),
          DataCell(
              Text(partner.vatNumber ?? '', style: CustomStyle.semibold14())),
          DataCell(Text(partner.registrationNumber ?? '',
              style: CustomStyle.semibold14())),
          DataCell(Container(
            alignment: Alignment.center,
            child: CustomActiveStatus(
              isActive: partner.isActive,
            ),
          )),
          DataCell(Container(
            alignment: Alignment.center,
            child: CustomEditButton(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return PartnerDetailsPopup(
                      partner: partner,
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
}

List<DataColumn2> getColumns(BuildContext context) {
  return [
    DataColumn2(
      label: Text(
        'name'.tr(context),
        style: CustomStyle.semibold16(color: CustomColor.greenGray),
      ),
      size: ColumnSize.L,
    ),
    DataColumn2(
      label: Text(
        'partner_type'.tr(context),
        style: CustomStyle.semibold16(color: CustomColor.greenGray),
      ),
      size: ColumnSize.M,
    ),
    DataColumn2(
      label: Text(
        'vat_personal_number'.tr(context),
        style: CustomStyle.semibold16(color: CustomColor.greenGray),
      ),
      size: ColumnSize.M,
    ),
    DataColumn2(
      label: Text(
        'registration_number'.tr(context),
        style: CustomStyle.semibold16(color: CustomColor.greenGray),
      ),
      size: ColumnSize.M,
    ),
    DataColumn2(
      label: Container(
          alignment: Alignment.center,
          child: Text(
            'active'.tr(context), // Assuming 'tr' is a method for translations
            style: CustomStyle.semibold16(color: CustomColor.greenGray),
          )),
      size: ColumnSize.L,
    ),
    DataColumn2(
        label: Container(
            alignment: Alignment.center,
            child: Text(
              'edit'.tr(context),
              style: CustomStyle.semibold16(color: CustomColor.greenGray),
            )),
        fixedWidth: 100),
  ];
}
