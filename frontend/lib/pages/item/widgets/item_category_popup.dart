import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/models/item/item_category_model.dart';
import 'package:erp_frontend_v2/models/item/um_model.dart';
import 'package:erp_frontend_v2/utils/util_widgets.dart';
import 'package:erp_frontend_v2/widgets/buttons/primary_button.dart';
import 'package:erp_frontend_v2/widgets/buttons/secondary_button.dart';
import 'package:erp_frontend_v2/widgets/custom_text_field_1.dart';
import 'package:erp_frontend_v2/widgets/custom_toggle.dart';
import 'package:erp_frontend_v2/widgets/dialog_widgets/custom_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../constants/style.dart';
import '../../../providers/item_provider.dart';
import '../../../services/item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ItemCategoryPopup extends ConsumerStatefulWidget {
  const ItemCategoryPopup({super.key, this.category});
  final ItemCategory? category;

  @override
  ConsumerState<ItemCategoryPopup> createState() => _ItemCategoryPopupState();
}

class _ItemCategoryPopupState extends ConsumerState<ItemCategoryPopup>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ItemCategory _category = ItemCategory.empty();

  bool validateOnSave = false;
  bool formIsValid = true;

  String categoryId = '';

  @override
  void initState() {
    super.initState();

    _category = widget.category ?? ItemCategory.empty();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 450,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    widget.category != null
                        ? Text(
                            'edit_item_category'.tr(context),
                            style: CustomStyle.bold24(),
                          )
                        : Text(
                            'add_item_category'.tr(context),
                            style: CustomStyle.bold24(),
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
                ),
                Gap(24),
                CustomTextField1(
                  initialValue: _category.name,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'error_required_field'.tr(context);
                    }
                    return null;
                  },
                  keyboardType: TextInputType.name,
                  labelText: 'name'.tr(context),
                  onValueChanged: (value) {
                    _category.name = value;
                  },
                  required: true,
                ),
                Gap(16),
                CustomToggle(
                  title: 'active'.tr(context),
                  subtitle: 'measurement_unit_activ_description'.tr(context),
                  initialValue: _category.isActive,
                  onChanged: (value) {
                    _category.isActive = value;
                  },
                ),
                Gap(16),
                CustomToggle(
                  title: 'final_product'.tr(context),
                  subtitle:
                      'item_category_final_product_description'.tr(context),
                  initialValue: _category.generatePn,
                  onChanged: (value) {
                    _category.generatePn = value;
                  },
                ),
                Gap(40),
                Row(
                  mainAxisSize: MainAxisSize.max,
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
                        text: 'save'.tr(context),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              await ItemService()
                                  .saveItemCategory(itemCategory: _category);

                              ref
                                  .read(itemCategoryProvider.notifier)
                                  .refreshItemCategories();
                              Navigator.of(context).pop();
                              showToast(
                                  _category.id == null
                                      ? 'suceess_add_category'.tr(context)
                                      : 'suceess_edit_category'.tr(context),
                                  ToastType.success);
                            } catch (e) {
                              Navigator.of(context).pop();
                              showToast('error'.tr(context), ToastType.error);
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
