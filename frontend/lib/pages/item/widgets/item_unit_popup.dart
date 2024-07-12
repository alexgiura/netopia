import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/models/item/um_model.dart';
import 'package:erp_frontend_v2/utils/util_widgets.dart';
import 'package:erp_frontend_v2/widgets/buttons/primary_button.dart';
import 'package:erp_frontend_v2/widgets/buttons/secondary_button.dart';
import 'package:erp_frontend_v2/widgets/custom_text_field_1.dart';
import 'package:erp_frontend_v2/widgets/custom_toggle.dart';
import 'package:erp_frontend_v2/widgets/dialog_widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../constants/style.dart';
import '../../../providers/item_provider.dart';
import '../../../services/item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ItemUnitPopup extends ConsumerStatefulWidget {
  const ItemUnitPopup({super.key, this.um});
  final Um? um;
  // final void Function(ItemCategory) onSave;
  @override
  ConsumerState<ItemUnitPopup> createState() => _ItemUnitPopupState();
}

class _ItemUnitPopupState extends ConsumerState<ItemUnitPopup>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _itemUnitFormKey = GlobalKey<FormState>();

  Um _um = Um.empty();

  bool validateOnSave = false;
  bool formIsValid = true;

  String umId = '';

  @override
  void initState() {
    super.initState();

    _um = widget.um ?? Um.empty();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 450,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _itemUnitFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    widget.um != null
                        ? Text(
                            'edit_measurement_unit'.tr(context),
                            style: CustomStyle.bold24(),
                          )
                        : Text(
                            'add_measurement_unit'.tr(context),
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
                  initialValue: _um.name,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'error_required_field'.tr(context);
                    }
                    return null;
                  },
                  keyboardType: TextInputType.name,
                  labelText: 'name'.tr(context),
                  onValueChanged: (value) {
                    _um.name = value;
                  },
                  required: true,
                ),
                Gap(4),
                CustomTextField1(
                  initialValue: _um.name,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'error_required_field'.tr(context);
                    }
                    return null;
                  },
                  keyboardType: TextInputType.name,
                  labelText: 'efactura_standard_code'.tr(context),
                  helperText: buildTextWithLink(
                    text: 'check_measurement_unit_list'.tr(context),
                    linkText: 'here'.tr(context),
                    url: Uri.parse(
                        "https://happyweb.ro//public/uploads/e-factura-unitati-masura.xlsx"),
                    textStyle:
                        CustomStyle.semibold12(color: CustomColor.slate_400),
                    linkStyle: CustomStyle.semibold12(
                        color: CustomColor.textPrimary, isUnderline: true),
                  ),
                  onValueChanged: (value) {
                    _um.code = value;
                  },
                  required: true,
                ),
                Gap(24),
                CustomToggle(
                  title: 'active'.tr(context),
                  subtitle: 'measurement_unit_activ_description'.tr(context),
                  initialValue: _um.isActive,
                  onChanged: (value) {
                    _um.isActive = value;
                  },
                ),
                Gap(40),
                Row(
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
                        text: 'save'.tr(context),
                        onPressed: () async {
                          if (_itemUnitFormKey.currentState!.validate()) {
                            try {
                              await ItemService().saveUm(um: _um);

                              ref
                                  .read(itemUnitsProvider.notifier)
                                  .refreshItemUnits();
                              Navigator.of(context).pop();
                              showToast(
                                  _um.id == null
                                      ? 'suceess_add_um'.tr(context)
                                      : 'suceess_edit_um'.tr(context),
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
