import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/models/document/document_model.dart';
import 'package:erp_frontend_v2/models/item/item_model.dart';
import 'package:erp_frontend_v2/pages/document/document_add_item/widget/filtered_item_list_widget.dart';
import 'package:erp_frontend_v2/providers/item_provider.dart';
import 'package:erp_frontend_v2/widgets/buttons/primary_button.dart';
import 'package:erp_frontend_v2/widgets/buttons/secondary_button.dart';
import 'package:erp_frontend_v2/widgets/custom_search_bar.dart';
import 'package:erp_frontend_v2/widgets/filters/drop_down_filter/widgets/filtered_list_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class AddItemPopup extends ConsumerWidget {
  const AddItemPopup({super.key, required this.callback});
  final void Function(List<DocumentItem>) callback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsState = ref.watch(itemsProvider);

    GlobalKey<FilteredItemListWidgetState> filteredListKey = GlobalKey();
    List<Item> filterdList = [];
    List<Item> checkedItems = [];
    return Dialog(
      child: SizedBox(
        height: 600,
        width: 500,
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildHeader(context),
              Gap(16),
              itemsState.when(
                data: (itemList) {
                  filterdList = itemList;
                  return Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: CustomSearchBar(
                              hintText: 'item_hint_search'.tr(context),
                              onValueChanged: (value) {
                                List<Item> newFilteredDataList =
                                    itemList.where((item) {
                                  final name = item.name;
                                  return name
                                      .toLowerCase()
                                      .contains(value.toLowerCase());
                                }).toList();
                                filteredListKey.currentState
                                    ?.updateList(newFilteredDataList);
                              },
                            ))
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: FilteredItemListWidget(
                              key: filteredListKey,
                              initialDataList: filterdList,
                              checkedItems: checkedItems,
                            ),
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
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SecondaryButton(
                        text: 'close'.tr(context),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    const Gap(16),
                    Expanded(
                      child: PrimaryButton(
                        text: 'add'.tr(context),
                        onPressed: () async {
                          final documentItems = checkedItems.map((item) {
                            return DocumentItem(
                              item: item,
                              quantity: 0.0,
                            );
                          }).toList();
                          callback(documentItems);
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'add_item'.tr(context),
              style: CustomStyle.bold24(),
            ),
            Text(
              'add_item_hint'.tr(context),
              style: CustomStyle.regular14(color: CustomColor.greenGray),
            ),
          ],
        ),
        const Spacer(),
        InkWell(
          child: const Icon(
            Icons.close,
            size: 24,
          ),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
