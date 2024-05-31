import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/models/item/item_category_model.dart';
import 'package:erp_frontend_v2/models/item/item_model.dart';
import 'package:erp_frontend_v2/providers/item_provider.dart';
import 'package:erp_frontend_v2/utils/date.dart';
import 'package:erp_frontend_v2/widgets/custom_dropdown.dart';
import 'package:erp_frontend_v2/widgets/custom_search_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../custom_date_picker.dart';

class FilterSectionLargeItemStockReport extends ConsumerStatefulWidget {
  final void Function(
    DateTime date,
    int? inventoryId,
    int? itemCategoryId,
    String? itemId,
  ) onChanged;

  final void Function() onPressed;

  const FilterSectionLargeItemStockReport({
    super.key,
    required this.onChanged,
    required this.onPressed,
  });

  @override
  ConsumerState<FilterSectionLargeItemStockReport> createState() =>
      _FilterSectionLargeItemStockReportState();
}

class _FilterSectionLargeItemStockReportState
    extends ConsumerState<FilterSectionLargeItemStockReport> {
  DateTime date = DateTime.now().startOfDay;
  ItemCategory itemCategory = ItemCategory.empty();
  Item item = Item.empty();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      //color: Colors.transparent,
      decoration: CustomStyle.customContainerDecoration,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: DatePickerWidget(
                labelText: 'Data',
                onDateChanged: (DateTime? value) {
                  setState(() {
                    date = value!;
                    widget.onChanged(date, 1, itemCategory.id!, item.id!);
                  });
                },
              )),
              SizedBox(
                width: width / 64,
              ),
              Expanded(
                flex: 1,
                child: SearchDropDown(
                  labelText: 'Categorie Produs',
                  hintText: 'Alege o categorie',
                  onValueChanged: (value) {
                    setState(
                      () {
                        itemCategory = (value as dynamic);
                        widget.onChanged(
                            date, 1, itemCategory.id, item.id.toString());
                      },
                    );
                  },
                  initialValue: itemCategory,
                  provider: itemCategoryProvider,
                ),
              ),
              SizedBox(
                width: width / 64,
              ),
              Expanded(
                flex: 1,
                child:
                    //

                    Consumer(
                  builder: (context, watch, _) {
                    final data = ref.refresh(itemsProvider).value ?? [];

                    return CustomDropdown(
                      labelText: 'Produs',
                      hintText: 'Alege un produs',
                      onValueChanged: (value) {
                        setState(
                          () {
                            item = (value as dynamic);
                            widget.onChanged(
                                date, 1, itemCategory.id, item.id.toString());
                          },
                        );
                      },
                      dataList: data,
                      initialValue: item,
                    );
                  },
                ),
              ),
              Spacer(),
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          Row(
            children: [
              SizedBox(
                height: 35,
                child: ElevatedButton.icon(
                  style: CustomStyle.activeButton,
                  onPressed: () {
                    widget.onPressed();
                  },
                  icon: const Icon(
                    Icons.search_outlined,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Genereaza',
                    style: CustomStyle.primaryButtonText,
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    itemCategory = ItemCategory.empty();
                    item = Item.empty();
                  });
                  widget.onChanged(
                      date, 1, itemCategory.id, item.id.toString());
                  widget.onPressed();
                },
                style: CustomStyle.tertiaryButton,
                child: Text('Clear', style: CustomStyle.tertiaryButtonText),
              )
            ],
          )
        ],
      ),
    );
  }
}
