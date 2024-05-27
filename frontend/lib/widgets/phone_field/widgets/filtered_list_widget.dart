import 'package:erp_frontend_v2/widgets/custom_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/countries.dart';

class CountryFilteredListWidget<T> extends StatefulWidget {
  final List<Country> initialDataList;
  final List<T>? checkedItems;
  final Function(bool, Country) onItemChanged;

  const CountryFilteredListWidget({
    Key? key,
    required this.initialDataList,
    required this.checkedItems,
    required this.onItemChanged,
  }) : super(key: key);

  @override
  CountryFilteredListWidgetState<T> createState() =>
      CountryFilteredListWidgetState<T>();
}

class CountryFilteredListWidgetState<T>
    extends State<CountryFilteredListWidget<T>> {
  List<Country> _dataList = [];
  List<T> _checkedItems = [];

  @override
  void initState() {
    super.initState();
    _dataList = widget.initialDataList;
    if (widget.checkedItems != null) {
      _checkedItems = widget.checkedItems!;
    }
  }

  void updateList(List<Country> newDataList) {
    setState(() {
      _dataList = newDataList;
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
