import 'package:erp_frontend_v2/widgets/custom_list_tile.dart';
import 'package:flutter/material.dart';

class FilteredListWidget<T> extends StatefulWidget {
  final List<T> initialDataList;
  final List<T>? checkedItems;
  final Function(bool, T) onItemChanged;

  const FilteredListWidget({
    Key? key,
    required this.initialDataList,
    required this.checkedItems,
    required this.onItemChanged,
  }) : super(key: key);

  @override
  FilteredListWidgetState<T> createState() => FilteredListWidgetState<T>();
}

class FilteredListWidgetState<T> extends State<FilteredListWidget<T>> {
  List<T> _dataList = [];
  List<T> _checkedItems = [];

  @override
  void initState() {
    super.initState();
    _dataList = widget.initialDataList;
    if (widget.checkedItems != null) {
      _checkedItems = widget.checkedItems!;
    }
  }

  void updateList(List<T> newDataList) {
    setState(() {
      _dataList = newDataList;
    });
  }

  void updateCheckedItems(List<T> newCheckedItems) {
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
        final name = ((item as dynamic).name);

        return CustomListTile(
          title: name,
          isChecked:
              widget.checkedItems != null ? _checkedItems.contains(item) : null,
          onChanged: (bool newValue) {
            widget.onItemChanged(newValue, item);
          },
        );
      },
    );
  }
}
