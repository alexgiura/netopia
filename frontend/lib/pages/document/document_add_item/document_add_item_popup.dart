import 'package:erp_frontend_v2/models/document/document_model.dart';
import 'package:erp_frontend_v2/pages/document/document_add_item/widget/document_add_item_data_table.dart';
import 'package:erp_frontend_v2/providers/item_provider.dart';
import 'package:erp_frontend_v2/widgets/custom_search_bar.dart';
import 'package:erp_frontend_v2/widgets/filter_section/filter_section_large_2_noCard.dart';
import 'package:erp_frontend_v2/widgets/filters/drop_down_filter/widgets/filtered_list_widget.dart';
import 'package:flutter/material.dart';

import '../../../models/item/item_model.dart';
import '../../../models/item/item_filter_model.dart';
import '../../../services/item.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddItemPopup extends ConsumerStatefulWidget {
  const AddItemPopup({super.key, this.item, required this.onSave});
  final DocumentItem? item;
  final void Function(DocumentItem) onSave;
  @override
  ConsumerState<AddItemPopup> createState() => _AddItemPopupState();
}

class _AddItemPopupState extends ConsumerState<AddItemPopup>
    with SingleTickerProviderStateMixin {
  List<Item> _filterdList = [];

  GlobalKey<DocumentAddItemDataTableState> dataTableKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final itemsState = ref.watch(itemsProvider);
    return AlertDialog(
      titlePadding: const EdgeInsets.all(16),
      contentPadding: const EdgeInsets.all(0),
      // title: const Text('Cauta Produs'),
      content: Container(
        height: 600,
        width: 500,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: itemsState.when(
            data: (itemList) {
              _filterdList = itemList;
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 4,
                      ),
                      Expanded(
                          child: CustomSearchBar(
                        hintText: 'Cauta produs dupa cod sau denumire',
                        onValueChanged: (value) {
                          List<Item> newFilteredDataList =
                              itemList.where((item) {
                            final name = item.name;
                            return name
                                .toLowerCase()
                                .contains(value.toLowerCase());
                          }).toList();

                          dataTableKey.currentState
                              ?.updateList(newFilteredDataList);
                        },
                        visibleBorder: false,
                      ))
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: DocumentAddItemDataTable(
                        key: dataTableKey,
                        data: _filterdList,
                        onSave: widget.onSave,
                      ),
                    ),
                  )
                ],
              );
            },
            loading: () {
              // Show a progress indicator while loading
              return const Center(
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
      // actions: <Widget>[
      //   TextButton(
      //     onPressed: () {},
      //     child: const Text('Adauga'),
      //   ),
      //   TextButton(
      //     onPressed: () {
      //       Navigator.of(context).pop(); // Close the popup
      //     },
      //     child: const Text('Renunta'),
      //   ),
      // ],
    );
  }
}
