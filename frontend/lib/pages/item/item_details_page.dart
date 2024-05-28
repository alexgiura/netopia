import 'package:erp_frontend_v2/widgets/custom_checkbox.dart';
import 'package:erp_frontend_v2/widgets/custom_search_dropdown.dart';
import 'package:flutter/material.dart';

import '../../constants/style.dart';
import '../../models/item/item_model.dart';
import '../../providers/item_provider.dart';
import '../../utils/customSnackBar.dart';
import '../../widgets/custom_text_field.dart';
import '../../services/item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ItemDetailsPopup extends ConsumerStatefulWidget {
  const ItemDetailsPopup({super.key, this.item});
  final Item? item;
  // final void Function(Item) onSave;
  @override
  ConsumerState<ItemDetailsPopup> createState() => _ItemDetailsPopupState();
}

class _ItemDetailsPopupState extends ConsumerState<ItemDetailsPopup>
    with SingleTickerProviderStateMixin {
  // Tab
  late TabController _tabController;

  // FormKey for validation
  final GlobalKey<CustomTextFieldState> nameFormKey =
      GlobalKey<CustomTextFieldState>();
  final GlobalKey<SearchDropDownState> umFormKey =
      GlobalKey<SearchDropDownState>();
  final GlobalKey<SearchDropDownState> vatFormKey =
      GlobalKey<SearchDropDownState>();

  final TextEditingController _textController = TextEditingController();

  late Item _item;
  bool validateOnSave = false;
  bool formIsValid = true;
  bool _isLoading = false;
  String umId = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 1, vsync: this);
    _item = widget.item ?? Item.empty();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // // Validation logic function
  // bool _isValid(String value) {
  //   if (value.isEmpty) {
  //     formIsValid = false;
  //     return false;
  //   }
  //   return true;
  // }

  Future<void> _saveItem(Item item) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final itemService = ItemService();
      final String result = await itemService.saveItem(item: item);

      setState(() {
        _isLoading = false;
      });

      if (result == 'success') {
        //upate item provier
        ref.read(itemProvider.notifier).refreshItems();

        if (context.mounted) {
          showSnackBar(context, 'Produsul a fost salvat!',
              const TextStyle(fontSize: 16));
          Navigator.of(context).pop();
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
      title: _item.isEmpty()
          ? const Text('Adauga Produs')
          : const Text('Editeaza Produs', style: CustomStyle.titleText),
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
                  labelText: "Cod (optional)",
                  hintText: null,
                  initialValue: _item.code,
                  onValueChanged: (String value) {
                    _item.code = value;
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                CustomTextField(
                  key: nameFormKey,
                  labelText: "Denumire *",
                  hintText: null,
                  initialValue: _item.name,
                  //textController: _textController,
                  onValueChanged: (String value) {
                    _item.name = value;
                  },
                  errorText: "Camp obligatoriu",
                ),
                const SizedBox(
                  height: 8,
                ),
                SearchDropDown(
                  key: umFormKey,
                  labelText: 'UM *',
                  onValueChanged: (value) {
                    setState(
                      () {
                        _item.um = value;
                      },
                    );
                  },
                  provider: umProvider,
                  errorText: "Camp obligatoriu",
                ),
                const SizedBox(
                  height: 8,
                ),
                SearchDropDown(
                  key: vatFormKey,
                  labelText: 'TVA *',
                  onValueChanged: (value) {
                    setState(
                      () {
                        _item.vat = value;
                      },
                    );
                  },
                  provider: vatProvider,
                  errorText: "Camp obligatoriu",
                ),
                const SizedBox(
                  height: 8,
                ),
                SearchDropDown(
                  labelText: 'Clasificare (optional)',
                  onValueChanged: (value) {
                    setState(
                      () {
                        _item.category = value;
                      },
                    );
                  },
                  provider: itemCategoryProvider,
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    CustomCheckbox(
                        value: _item.isActive ?? false,
                        labelText: "Activ",
                        onChanged: (value) {
                          setState(() {
                            _item.isActive = value;
                          });
                        }),
                    const SizedBox(
                      width: 16,
                    ),
                    CustomCheckbox(
                        value: _item.isStock ?? false,
                        labelText: "Stocabil",
                        onChanged: (value) {
                          setState(() {
                            _item.isStock = value;
                          });
                        }),
                  ],
                ),
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
            if (nameFormKey.currentState!.valid() &&
                umFormKey.currentState!.valid() &&
                vatFormKey.currentState!.valid()) {
              _saveItem(_item);
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
