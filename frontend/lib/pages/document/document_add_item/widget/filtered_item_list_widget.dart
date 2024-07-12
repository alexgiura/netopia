import 'package:erp_frontend_v2/models/item/item_model.dart';
import 'package:erp_frontend_v2/pages/document/document_add_item/widget/item_list_tile.dart';
import 'package:erp_frontend_v2/widgets/custom_list_tile.dart';
import 'package:flutter/material.dart';

class FilteredItemListWidget extends StatefulWidget {
  final List<Item> initialDataList;
  final List<Item>? checkedItems;
  // final Function(bool, Item) onItemChanged;

  const FilteredItemListWidget({
    Key? key,
    required this.initialDataList,
    required this.checkedItems,
    // required this.onItemChanged,
  }) : super(key: key);

  @override
  FilteredItemListWidgetState createState() => FilteredItemListWidgetState();
}

class FilteredItemListWidgetState extends State<FilteredItemListWidget> {
  List<Item> _dataList = [];
  List<Item> _checkedItems = [];

  @override
  void initState() {
    super.initState();
    _dataList = widget.initialDataList;
    if (widget.checkedItems != null) {
      _checkedItems = widget.checkedItems!;
    }
  }

  void updateList(List<Item> newDataList) {
    setState(() {
      _dataList = newDataList;
    });
  }

  void updateCheckedItems(List<Item> newCheckedItems) {
    setState(() {
      _checkedItems = newCheckedItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _dataList.length,
      itemBuilder: (context, index) {
        final item = _dataList[index];

        return ItemListTile(
          item: _dataList[index],
          isChecked:
              widget.checkedItems != null ? _checkedItems.contains(item) : null,
          onChanged: (bool newValue) {
            setState(() {
              if (newValue) {
                _checkedItems.add(item);
              } else {
                _checkedItems.remove(item);
              }
            });
          },
        );
      },
    );
  }
}
