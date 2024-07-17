import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/utils/extensions.dart';
import 'package:erp_frontend_v2/widgets/buttons/primary_button.dart';
import 'package:erp_frontend_v2/widgets/buttons/secondary_button.dart';
import 'package:erp_frontend_v2/widgets/custom_checkbox.dart';
import 'package:erp_frontend_v2/widgets/not_used_widgets/custom_search_dropdown.dart';
import 'package:erp_frontend_v2/widgets/custom_search_dropdown.dart';
import 'package:erp_frontend_v2/widgets/custom_text_field_1.dart';
import 'package:erp_frontend_v2/widgets/custom_toggle.dart';
import 'package:erp_frontend_v2/widgets/dialog_widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../constants/style.dart';
import '../../models/item/item_model.dart';
import '../../providers/item_provider.dart';
import '../../widgets/custom_text_field.dart';
import '../../services/item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ItemDetailsPopup extends ConsumerStatefulWidget {
  const ItemDetailsPopup({super.key, this.item});
  final Item? item;

  @override
  ConsumerState<ItemDetailsPopup> createState() => _ItemDetailsPopupState();
}

class _ItemDetailsPopupState extends ConsumerState<ItemDetailsPopup> {
  final GlobalKey<FormState> _itemFormKey = GlobalKey<FormState>();

  Item _item = Item.empty();

  @override
  void initState() {
    super.initState();

    _item = widget.item ?? Item.empty();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 450,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _itemFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    widget.item != null
                        ? Text(
                            'edit_item'.tr(context),
                            style: CustomStyle.bold24(),
                          )
                        : Text(
                            'add_item'.tr(context),
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
                  initialValue: _item.code,
                  keyboardType: TextInputType.name,
                  labelText: 'code'.tr(context),
                  hintText: 'item_code'.tr(context),
                  onValueChanged: (String value) {
                    _item.code = value;
                  },
                ),
                Gap(4),
                CustomTextField1(
                  initialValue: _item.name,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'error_required_field'.tr(context);
                    }
                    return null;
                  },
                  keyboardType: TextInputType.name,
                  labelText: 'name'.tr(context),
                  hintText: 'item_name'.tr(context),
                  onValueChanged: (String value) {
                    _item.name = value;
                  },
                  required: true,
                ),
                Gap(4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: SearchDropDown(
                        initialValue: _item.um,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'error_required_field'.tr(context);
                          }
                          return null;
                        },
                        labelText: 'um'.tr(context),
                        hintText: 'select_um'.tr(context),
                        onValueChanged: (value) {
                          _item.um = value;
                        },
                        provider: itemUnitsProvider,
                        required: true,
                      ),
                    ),
                    Gap(context.width01),
                    Flexible(
                      child: SearchDropDown(
                        initialValue: _item.vat,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'error_required_field'.tr(context);
                          }
                          return null;
                        },
                        labelText: 'vat'.tr(context),
                        hintText: 'select_vat'.tr(context),
                        onValueChanged: (value) {
                          _item.vat = value;
                        },
                        provider: itemVatProvider,
                        required: true,
                      ),
                    ),
                  ],
                ),
                Gap(4),
                SearchDropDown(
                  initialValue: _item.category,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'error_required_field'.tr(context);
                    }
                    return null;
                  },
                  labelText: 'category'.tr(context),
                  hintText: 'select_item_category'.tr(context),
                  onValueChanged: (value) {
                    _item.category = value;
                  },
                  provider: itemCategoryProvider,
                ),
                Gap(16),
                CustomToggle(
                  title: 'active'.tr(context),
                  subtitle: 'item_activ_description'.tr(context),
                  initialValue: _item.isActive,
                  onChanged: (value) {
                    _item.isActive = value;
                  },
                ),
                Gap(16),
                CustomToggle(
                  title: 'is_stock'.tr(context),
                  subtitle: 'item_stock_description'.tr(context),
                  initialValue: _item.isStock ?? false,
                  onChanged: (value) {
                    _item.isStock = value;
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
                          if (_itemFormKey.currentState!.validate()) {
                            try {
                              await ItemService().saveItem(item: _item);

                              ref.read(itemProvider.notifier).refreshItems();
                              Navigator.of(context).pop();
                              showToast(
                                  _item.id == null
                                      ? 'suceess_add_item'.tr(context)
                                      : 'suceess_edit_item'.tr(context),
                                  ToastType.success);
                            } catch (e) {
                              Navigator.of(context).pop();
                              showToast('error_try_again'.tr(context),
                                  ToastType.error);
                            }
                            // }
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
