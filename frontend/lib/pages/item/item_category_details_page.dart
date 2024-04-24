import 'package:erp_frontend_v2/models/item/item_category_model.dart';
import 'package:erp_frontend_v2/widgets/custom_checkbox.dart';
import 'package:erp_frontend_v2/widgets/custom_dropdown.dart';
import 'package:flutter/material.dart';

import '../../constants/style.dart';
import '../../models/item/item_model.dart';
import '../../providers/item_provider.dart';
import '../../utils/customSnackBar.dart';
import '../../widgets/custom_text_field.dart';
import '../../services/item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ItemCategoryDetailsPopup extends ConsumerStatefulWidget {
  const ItemCategoryDetailsPopup(
      {super.key, this.itemCategory, required this.onSave});
  final ItemCategory? itemCategory;
  final void Function(ItemCategory) onSave;
  @override
  ConsumerState<ItemCategoryDetailsPopup> createState() =>
      _ItemCategoryDetailsPopupState();
}

class _ItemCategoryDetailsPopupState
    extends ConsumerState<ItemCategoryDetailsPopup>
    with SingleTickerProviderStateMixin {
  // FormKey for validation
  final GlobalKey<CustomTextFieldState> nameFormKey =
      GlobalKey<CustomTextFieldState>();

  late ItemCategory _itemCategory;
  bool validateOnSave = false;
  bool formIsValid = true;
  bool _isLoading = false;
  String umId = '';

  @override
  void initState() {
    super.initState();

    _itemCategory = widget.itemCategory ?? ItemCategory.empty();
  }

  Future<void> _saveItemCategory(ItemCategory itemCategory) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final itemService = ItemService();
      final String result =
          await itemService.saveItemCategory(itemCategory: itemCategory);

      setState(() {
        _isLoading = false;
      });

      if (result == 'success') {
        widget.onSave(itemCategory);
        ref.refresh(itemCategoryProvider);
        if (context.mounted) {
          // showSnackBar(
          //     context: context,
          //     backgroundColor: Colors.green,
          //     text: 'Categoria a fost salvata!',
          //     style: const TextStyle(fontSize: 16));
          // Navigator.of(context).pop();
        }
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          behavior: SnackBarBehavior.floating, // Move SnackBar to top
          backgroundColor: Colors.red, // Change background color
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: CustomColor.white,
      titlePadding: EdgeInsets.all(16),
      contentPadding: EdgeInsets.all(0),
      title: _itemCategory.isEmpty()
          ? const Text('Adauga Categorie')
          : const Text('Editeaza Categorie', style: CustomStyle.titleText),
      content: Container(
        color: CustomColor.white,
        //height: 600,
        width: 400,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(
                  height: 8,
                ),
                CustomTextField(
                  key: nameFormKey,
                  labelText: "Denumire *",
                  hintText: null,
                  initialValue: _itemCategory.name,
                  onValueChanged: (String value) {
                    _itemCategory.name = value;
                  },
                  errorText: "Camp obligatoriu",
                ),
                const SizedBox(
                  height: 16,
                ),
                CustomCheckbox(
                    value: _itemCategory.isActive,
                    labelText: "Activ",
                    onChanged: (value) {
                      setState(() {
                        _itemCategory.isActive = value;
                      });
                    }),
                const SizedBox(
                  height: 16,
                ),
                CustomCheckbox(
                    value: _itemCategory.generatePn!,
                    labelText: "Produs Finit",
                    onChanged: (value) {
                      setState(() {
                        _itemCategory.generatePn = value;
                      });
                    }),
                const SizedBox(
                  height: 32,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            if (nameFormKey.currentState!.valid()) {
              _saveItemCategory(_itemCategory).then((value) => {
                    Navigator.of(context).pop() // Close the popup
                  });
            }
          },
          child: Text('Save'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the popup
          },
          child: Text('Close'),
        ),
      ],
    );
  }
}
