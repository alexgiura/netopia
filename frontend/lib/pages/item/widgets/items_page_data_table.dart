import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/models/item/item_filter_model.dart';
import 'package:erp_frontend_v2/models/item/item_model.dart';
import 'package:erp_frontend_v2/models/partner/partner_model.dart';
import 'package:erp_frontend_v2/models/partner/partner_type_model.dart';
import 'package:erp_frontend_v2/models/static_model.dart';
import 'package:erp_frontend_v2/pages/item/item_details_page.dart';
import 'package:erp_frontend_v2/providers/item_provider.dart';
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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../../../constants/style.dart';

class ItemsPageDataTable extends ConsumerStatefulWidget {
  const ItemsPageDataTable({
    super.key,
  });

  @override
  ConsumerState<ItemsPageDataTable> createState() => _ItemsPageDataTableState();
}

class _ItemsPageDataTableState extends ConsumerState<ItemsPageDataTable>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Partner> filteredData = [];
  String? _searchText;
  final List<bool> _selectStatus = [];
  ItemFilter _itemFilter = ItemFilter.empty();

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
    final itemState = ref.watch(itemProvider);

    return itemState.when(
      skipLoadingOnReload: true,
      skipLoadingOnRefresh: true,
      data: (itemList) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: CustomStyle.customContainerDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTabBar(
                tabController: _tabController,
                tabs: [
                  Tab(text: 'activ'.tr(context)),
                  Tab(text: 'inactiv'.tr(context)),
                  Tab(text: 'all'.tr(context)),
                ],
              ),
              const Gap(24),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 4,
                    child: CustomSearchBar(
                      hintText: 'item_hint_search'.tr(context),
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
                      labelText: 'item_type'.tr(context),
                      enableSearch: false,
                      onValueChanged: (selectedList) {
                        _itemFilter.categoryList = selectedList
                            .map((category) => category.id!)
                            .toList();
                        ref
                            .read(itemProvider.notifier)
                            .updateFilter(_itemFilter);
                      },
                      provider: itemCategoryProvider),
                  IconButton(
                    icon: const Icon(
                      Icons.refresh_rounded,
                      color: CustomColor.textPrimary,
                    ),
                    onPressed: () {
                      ref.read(itemProvider.notifier).refreshItems();
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
                  rows: getRows(itemList),
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

  List<DataRow2> getRows(List<Item> data) {
    List<Item> filteredData = data.where((row) {
      bool statusMatch =
          _selectStatus.isEmpty || _selectStatus.contains(row.isActive);

      bool searchTextMatch = _searchText == null ||
          _searchText!.isEmpty ||
          row.name.toLowerCase().contains(_searchText!.toLowerCase()) ||
          (row.code?.toLowerCase() ?? '').contains(_searchText!.toLowerCase());

      return statusMatch && searchTextMatch;
    }).toList();

    return filteredData.asMap().entries.map((row) {
      Item item = row.value;

      return DataRow2(
        cells: [
          DataCell(Text(item.code ?? '', style: CustomStyle.semibold14())),
          DataCell(Text(item.name, style: CustomStyle.semibold14())),
          DataCell(Text(item.um.name, style: CustomStyle.semibold14())),
          DataCell(
            Text(item.category != null ? row.value.category!.name : '',
                style: CustomStyle.semibold14()),
          ),
          DataCell(Container(
            alignment: Alignment.center,
            child: CustomActiveStatus(
              isActive: item.isActive,
            ),
          )),
          DataCell(Container(
            alignment: Alignment.center,
            child: CustomEditButton(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ItemDetailsPopup(
                      item: item,
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
      label: Text(
        'um'.tr(context),
        style: CustomStyle.semibold16(color: CustomColor.greenGray),
      ),
      size: ColumnSize.L,
    ),
    DataColumn2(
      label: Text(
        'category'.tr(context),
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
