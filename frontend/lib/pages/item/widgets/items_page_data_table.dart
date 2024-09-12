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
import 'package:erp_frontend_v2/widgets/buttons/icon_button.dart';
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
import 'package:hive/hive.dart';
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
  List<Partner> filteredData = [];
  String? _searchText;
  final List<bool> _selectStatus = [];
  ItemFilter _itemFilter = ItemFilter.empty();

  @override
  void initState() {
    super.initState();
    _activeItems();
  }

  void _allItems() {
    setState(() {
      _selectStatus.clear();
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
      _selectStatus.add(false);
    });
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
                tabs: [
                  Text('activ_feminin'.tr(context)),
                  Text('inactiv_feminin'.tr(context)),
                  Text('all_feminin'.tr(context)),
                ],
                onChanged: (value) {
                  setState(() {
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
                  CustomIconButton(
                    icon: Icons.refresh_rounded,
                    asyncOnPressed: () async {
                      ref.read(itemProvider.notifier).refreshItems();
                    },
                  ),
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
            child: CustomActiveStatus(
              isActive: item.isStock,
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
      size: ColumnSize.S,
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
      size: ColumnSize.S,
    ),
    DataColumn2(
      label: Text(
        'category'.tr(context),
        style: CustomStyle.semibold16(color: CustomColor.greenGray),
      ),
      size: ColumnSize.S,
    ),
    DataColumn2(
      label: Container(
          alignment: Alignment.center,
          child: Text(
            'active'.tr(context),
            style: CustomStyle.semibold16(color: CustomColor.greenGray),
          )),
      size: ColumnSize.S,
    ),
    DataColumn2(
      label: Container(
          alignment: Alignment.center,
          child: Text(
            'is_stock'.tr(context),
            style: CustomStyle.semibold16(color: CustomColor.greenGray),
          )),
      size: ColumnSize.S,
    ),
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
