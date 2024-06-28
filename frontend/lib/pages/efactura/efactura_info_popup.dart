import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/pages/efactura/efactura_error_popup.dart';
import 'package:erp_frontend_v2/widgets/buttons/primary_button.dart';
import 'package:erp_frontend_v2/widgets/buttons/secondary_button.dart';
import 'package:erp_frontend_v2/pages/efactura/widgets/custom_checkbox_listTile.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class EfacturaInfoPopup extends StatefulWidget {
  const EfacturaInfoPopup({super.key});

  @override
  State<EfacturaInfoPopup> createState() => _EfacturaInfoPopupState();
}

class _EfacturaInfoPopupState extends State<EfacturaInfoPopup> {
  bool _value1 = false;
  bool _value2 = false;
  bool _showError = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 400,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: CustomColor.accentColor.withOpacity(0.4),
                    child: const Icon(
                      Icons.receipt_long_outlined,
                      color: CustomColor.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    child: const Icon(Icons.close),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              const Gap(16.0),
              Text(
                'e_factura'.tr(context),
                style: CustomStyle.bold20(),
              ),
              const Gap(8.0),
              Text(
                'e_factura_description'.tr(context),
                style: CustomStyle.regular14(color: CustomColor.slate_500),
                softWrap: true, // Allow text to wrap
                overflow: TextOverflow.visible, // Handle overflow gracefully
              ),
              const Gap(24.0),
              Row(
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    color: CustomColor.warning,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'ensure_conditions'.tr(context),
                      style: CustomStyle.buttonMedium14(),
                    ),
                  ),
                ],
              ),
              const Gap(16.0),
              CustomCheckboxListTile(
                value: _value1,
                onChanged: (value) {
                  setState(() {
                    _value1 = value;

                    if (_showError == true) {
                      _showError = !(_value1 && _value2);
                    }
                  });
                },
                title: 'spv_access'.tr(context),
                subtitle: 'spv_access_info'.tr(context),
              ),
              Gap(16),
              CustomCheckboxListTile(
                value: _value2,
                onChanged: (value) {
                  setState(() {
                    _value2 = value;
                    if (_showError == true) {
                      _showError = !(_value1 && _value2);
                    }
                  });
                },
                title: 'cert_inserted_activated'.tr(context),
                subtitle: 'cert_info'.tr(context),
              ),
              Gap(8),
              Text(
                _showError ? 'err_ensure_conditions'.tr(context) : '',
                style: CustomStyle.labelSemibold12(color: CustomColor.error),
              ),
              Gap(32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SecondaryButton(
                      text: 'back'.tr(context),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Gap(16),
                  Expanded(
                    child: PrimaryButton(
                      text: 'continue'.tr(context),
                      onPressed: () {
                        if (!_value1 || !_value2) {
                          setState(() {
                            _showError = true;
                          });
                        } else {
                          Navigator.of(context).pop();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const EfacturaErrorPopup();
                            },
                          );
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
    );
  }
}
