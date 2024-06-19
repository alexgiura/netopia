import 'package:erp_frontend_v2/models/item/item_category_model.dart';
import 'package:erp_frontend_v2/models/item/item_filter_model.dart';
import 'package:erp_frontend_v2/models/item/item_model.dart';
import 'package:erp_frontend_v2/pages/item/item_details_page.dart';
import 'package:erp_frontend_v2/providers/item_provider.dart';
import 'package:erp_frontend_v2/widgets/custom_data_table.dart';
import 'package:erp_frontend_v2/widgets/filters/drop_down_filter/drop_down_filter.dart';
import 'package:erp_frontend_v2/widgets/filters/sort_widget.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../constants/style.dart';

class ItemsDataTable extends ConsumerStatefulWidget {
  const ItemsDataTable({super.key, this.status, this.searchText});

  final String? status;
  final String? searchText;

  @override
  ConsumerState<ItemsDataTable> createState() => _ItemsDataTableState();
}

class _ItemsDataTableState extends ConsumerState<ItemsDataTable> {
  String selectedHid = '';

  ItemFilter _itemFilter = ItemFilter.empty();

  @override
  void initState() {
    super.initState();

    Future.microtask(
        () => ref.read(itemProvider.notifier).updateFilter(_itemFilter));
  }

  @override
  Widget build(BuildContext context) {
    final itemState = ref.watch(itemProvider);
    //ref.read(documentProvider.notifier).updateFilter(_documentFilter);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            DropDownFilter(
              labelText: 'Tip produs',
              onValueChanged: (selectedList) {
                _itemFilter.categoryList =
                    selectedList.map((category) => category.id!).toList();
                ref.read(itemProvider.notifier).updateFilter(_itemFilter);
              },
              provider: itemCategoryProvider,
            ),
            const SizedBox(
              width: 8,
            ),
            IconButton(
              icon: Icon(
                Icons.refresh_rounded,
                color: CustomColor.active,
              ), // You can change the icon as needed
              onPressed: () {
                // Handle refresh logic here
                // _fetchDocuments();
              },
            ),
            Spacer(),
            SelectColumns()
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Expanded(
          child: Container(
            decoration: CustomStyle.customContainerDecoration(),
            child: itemState.when(
              data: (itemList) {
                return CustomDataTable(
                    columns: _columns, rows: getRows(itemList));
              },
              loading: () {
                // Show a progress indicator while loading
                return Center(
                  child:
                      CircularProgressIndicator(), // You can customize this indicator
                );
              },
              error: (error, stackTrace) {
                // Handle the case when the future encounters an error
                return Text("Error: $error");
              },
            ),
          ),
        ),
      ],
    );
  }

  List<DataRow2> getRows(List<Item> data) {
    // Filter data based on widget.status and widget.searchText
    List<Item> filteredData = data.where((row) {
      // bool statusMatch = widget.status == null || row.status == widget.status;
      bool searchTextMatch = widget.searchText == null ||
          widget.searchText!.isEmpty ||
          (row.code?.toLowerCase() ?? '')
              .contains(widget.searchText!.toLowerCase()) ||
          row.name.toLowerCase().contains(widget.searchText!.toLowerCase());
      return
          // statusMatch &&
          searchTextMatch;
    }).toList();

    return filteredData.asMap().entries.map((row) {
      int index = row.key;
      Item item = row.value; //
      return DataRow2(
        cells: [
          DataCell(Text(row.value.code ?? '')),
          DataCell(Text(row.value.name)),
          DataCell(Text(row.value.um.name)),
          DataCell(
              Text(row.value.category != null ? row.value.category!.name : '')),
          DataCell(
            Checkbox(
              activeColor: CustomColor.active,
              value: row.value.isStock,
              onChanged: (newValue) {
                // For read-only purposes, you can omit this onChanged callback.
              },
            ),
          ),
          DataCell(
            Checkbox(
              activeColor: CustomColor.active,
              value: row.value.isActive,
              onChanged: (newValue) {
                // For read-only purposes, you can omit this onChanged callback.
              },
            ),
          ),
          DataCell(
            IconButton(
              hoverColor: CustomColor.lightest,
              splashRadius: 22,
              icon: const Icon(Icons.edit_outlined,
                  color: CustomColor
                      .active), // Replace with your desired edit icon
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ItemDetailsPopup(
                      item: item,
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
  DataColumn2(
    label: Text('Cod'),
    size: ColumnSize.M,
  ),

  DataColumn2(
    label: Text('Denumire'),
    size: ColumnSize.L,
  ),

  DataColumn2(
    label: Text('UM'),
    size: ColumnSize.S,
  ),

  DataColumn2(
    label: Text('Categorie'),
    size: ColumnSize.M,
  ),

  DataColumn2(
    label: Text('Stocabil'),
    size: ColumnSize.S,
  ),
  DataColumn2(
    label: Text('Activ'),
    size: ColumnSize.S,
  ),

  /// Time Column definition
  DataColumn2(label: Text('Editează'), fixedWidth: 100),
];
