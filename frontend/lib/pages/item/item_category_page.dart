import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/models/item/item_category_model.dart';
import 'package:erp_frontend_v2/pages/item/widgets/item_category_popup.dart';
import 'package:erp_frontend_v2/pages/item/widgets/item_category_data_table.dart';
import 'package:flutter/material.dart';
import '../../helpers/responsiveness.dart';
import '../../services/item.dart';

class ItemCategoryPage extends StatefulWidget {
  const ItemCategoryPage({super.key});

  @override
  State<ItemCategoryPage> createState() => _ItemCategoryPageState();
}

class _ItemCategoryPageState extends State<ItemCategoryPage> {
  late bool _isLoading = false;
  late List<ItemCategory> _itemCategoryList = [];

  @override
  void initState() {
    super.initState();

    _isLoading = true;
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    try {
      final itemService = ItemService();
      final items = await itemService.getItemCategoryList();

      setState(() {
        _itemCategoryList = items;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomColor.lightest,
      padding: EdgeInsets.only(
        left: ResponsiveWidget.isSmallScreen(context) ? 0 : 24,
        right: ResponsiveWidget.isSmallScreen(context) ? 0 : 24,
        top: ResponsiveWidget.isSmallScreen(context) ? 56 : 32,
        bottom: ResponsiveWidget.isSmallScreen(context) ? 0 : 24,
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'Categorii Produse',
                style: CustomStyle.titleText,
              ),

              const Spacer(),

              SizedBox(
                height: 35,
                child: ElevatedButton.icon(
                  style: CustomStyle.activeButton,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ItemCategoryDetailsPopup(
                          itemCategory: null,
                          onSave: (newItemCategory) {
                            setState(() {
                              _itemCategoryList.add(newItemCategory);
                            });
                          },
                        );
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Adauga',
                    style: CustomStyle.primaryButtonText,
                  ),
                ),
              ),
              const SizedBox(
                  width: 10), // Adjust the spacing between the buttons
            ],
          ),
          const SizedBox(height: 16),
          Expanded(child: ItemCategoryPageDataTable(data: _itemCategoryList))
        ],
      ),
    );
  }
}
