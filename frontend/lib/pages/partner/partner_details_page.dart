import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/models/company/company_model.dart';
import 'package:erp_frontend_v2/models/partner/partner_model.dart';
import 'package:erp_frontend_v2/models/partner/partner_type_model.dart';
import 'package:erp_frontend_v2/pages/auth/widgets/step_indicator.dart';
import 'package:erp_frontend_v2/providers/partner_provider.dart';
import 'package:erp_frontend_v2/services/company.dart';
import 'package:erp_frontend_v2/services/partner.dart';
import 'package:erp_frontend_v2/utils/extensions.dart';
import 'package:erp_frontend_v2/widgets/buttons/primary_button.dart';
import 'package:erp_frontend_v2/widgets/buttons/secondary_button.dart';
import 'package:erp_frontend_v2/widgets/custom_checkbox.dart';
import 'package:erp_frontend_v2/widgets/custom_radio_button.dart';
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
import '../../utils/customSnackBar.dart';
import '../../widgets/custom_text_field.dart';
import '../../services/item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PartnerDetailsPopup extends ConsumerStatefulWidget {
  const PartnerDetailsPopup({super.key, this.partner});
  final Partner? partner;

  @override
  ConsumerState<PartnerDetailsPopup> createState() =>
      _PartnerDetailsPopupState();
}

class _PartnerDetailsPopupState extends ConsumerState<PartnerDetailsPopup> {
  final GlobalKey<FormState> _partnerFormKey = GlobalKey<FormState>();

  Partner _partner = Partner.empty();

  bool errorCompanyTaxId = false;

  int currentStep = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _partner = widget.partner ?? Partner.empty();
  }

  Future<Company?> _getCompanyByTaxId(String taxId) async {
    try {
      setState(() {
        _isLoading = true;
      });

      final companyService = CompanyService();

      Company? result = await companyService.getCompanyByTaxId(taxId);

      if (result != null) {
        if (context.mounted) {
          setState(() {
            errorCompanyTaxId = false;
            _isLoading = false;
          });
        }
        return result;
      } else {
        if (context.mounted) {
          setState(() {
            errorCompanyTaxId = true;
            _isLoading = false;
          });
        }

        return null;
      }
    } catch (error) {
      if (error.toString().contains('InvalidTaxId')) {
        setState(() {
          errorCompanyTaxId = true;
          _isLoading = false;
        });
      }

      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> titleList = [
      'generic_details'.tr(context),
      'partner_address'.tr(context),
      'bank_account'.tr(context)
    ];
    List _forms = [_firstStep(), _secondStep(), _thirdStep()];
    return Dialog(
      child: SizedBox(
        width: 500,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  widget.partner != null
                      ? Text(
                          'edit_partner'.tr(context),
                          style: CustomStyle.bold24(),
                        )
                      : Text(
                          'add_partner'.tr(context),
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
              StepIndicator(
                totalSteps: _forms.length,
                currentStep: currentStep,
                stepTitle: titleList,
              ),
              Gap(24),
              Flexible(child: _formBody()),
              Gap(40),
              _formNavigation(currentStep),
            ],
          ),
        ),
      ),
    );
  }

  Widget _formBody() {
    return IndexedStack(
      index: currentStep,
      children: [
        _firstStep(),
        _secondStep(),
        _thirdStep(),
      ],
    );
  }

  Future<void> _nextFormStep() async {
    if (currentStep == 0) {
      await _submitFirstStep();
    } else if (currentStep == 1) {
      await _submitSecondStep();
    } else if (currentStep == 2) {
      await _submitThirdStep();
    }
  }

  void _backFormStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
    }
  }

  Widget _firstStep() {
    return SingleChildScrollView(
      child: Form(
        key: _partnerFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField1(
              initialValue: _partner.vatNumber,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'error_required_field'.tr(context);
                }
                return null;
              },
              keyboardType: TextInputType.name,
              labelText: 'vat_personal_number'.tr(context),
              hintText: 'vat_personal_number_hint'.tr(context),
              sufixWidget: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              CustomColor.textPrimary),
                        ),
                      ),
                    )
                  : IconButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: () async {
                        Company? company =
                            await _getCompanyByTaxId(_partner.vatNumber ?? '');
                        if (company != null && !errorCompanyTaxId) {
                          setState(() {
                            _partner.type = PartnerType.company;
                            _partner.name = company.name;
                            _partner.vatNumber = company.vatNumber;
                            _partner.vat = company.vat;
                            _partner.registrationNumber =
                                company.registrationNumber;
                            _partner.address = company.address;
                          });
                        }
                      },
                      icon: Icon(Icons.cloud_download_outlined),
                      color: CustomColor.textPrimary,
                    ),
              onValueChanged: (String value) {
                _partner.vatNumber = value;
              },
              required: true,
            ),
            Flexible(
              child: SearchDropDown(
                initialValue: _partner.type,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'error_required_field'.tr(context);
                  }
                  return null;
                },
                labelText: 'partner_type'.tr(context),
                hintText: 'partner_type_hint'.tr(context),
                onValueChanged: (value) {
                  _partner.type = value;
                },
                provider: partnerTypeProvider,
                required: true,
              ),
            ),
            CustomTextField1(
              initialValue: _partner.name,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'error_required_field'.tr(context);
                }
                return null;
              },
              keyboardType: TextInputType.name,
              labelText: 'name'.tr(context),
              hintText: 'partner_name'.tr(context),
              onValueChanged: (String value) {
                _partner.name = value;
              },
              required: true,
            ),
            CustomTextField1(
              initialValue: _partner.code,
              keyboardType: TextInputType.name,
              labelText: 'code'.tr(context),
              hintText: 'partner_code'.tr(context),
              onValueChanged: (String value) {
                _partner.code = value;
              },
            ),
            CustomTextField1(
              initialValue: _partner.registrationNumber,
              keyboardType: TextInputType.name,
              labelText: 'registration_number'.tr(context),
              hintText: 'registration_number_hint'.tr(context),
              onValueChanged: (String value) {
                _partner.registrationNumber = value;
              },
            ),
            Gap(4),
            CustomRadioButton(
              errorText: 'error_vat_payer'.tr(context),
              text: "pay_TVA".tr(context),
              direction: Axis.horizontal,
              textStyle: CustomStyle.regular16(),
              // groupValue: _partner.vat != null ? _partner.vat == true ? 'yes' : 'no' : '',
              groupValue: _partner.vat != null
                  ? _partner.vat == true
                      ? 'yes'
                      : 'no'
                  : '',
              options: const ['yes', 'no'],
              onChanged: (value) {
                setState(() {
                  if (value == 'yes')
                    _partner.vat = true;
                  else
                    _partner.vat = false;
                });
                print(_partner.vat);
              },
            )
          ],
        ),
      ),
    );
  }

  Future<void> _submitFirstStep() async {
    if (_partnerFormKey.currentState!.validate()) {
      setState(() {
        currentStep++;
      });
    }
  }

  Widget _secondStep() {
    return SingleChildScrollView(
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField1(
              initialValue: _partner.address?.address,
              keyboardType: TextInputType.name,
              labelText: 'address'.tr(context),
              hintText: 'address_hint'.tr(context),
              onValueChanged: (String value) {
                _partner.address?.address = value;
              },
            ),
            Gap(4),
            CustomTextField1(
              initialValue: _partner.address?.countyCode,
              keyboardType: TextInputType.name,
              labelText: 'state'.tr(context),
              hintText: 'state_hint'.tr(context),
              onValueChanged: (String value) {
                _partner.address?.countyCode = value;
              },
            ),
            Gap(4),
            CustomTextField1(
              initialValue: _partner.address?.locality,
              keyboardType: TextInputType.name,
              labelText: 'locality'.tr(context),
              hintText: 'locality_hint'.tr(context),
              onValueChanged: (String value) {
                _partner.address?.locality = value;
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitSecondStep() async {
    setState(() {
      currentStep++;
    });
  }

  Widget _thirdStep() {
    return SingleChildScrollView(
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField1(
              keyboardType: TextInputType.name,
              labelText: 'bank'.tr(context),
              hintText: 'bank_hint'.tr(context),
              onValueChanged: (String value) {
                _partner.code = value;
              },
            ),
            Gap(4),
            CustomTextField1(
              keyboardType: TextInputType.name,
              labelText: 'iban'.tr(context),
              hintText: 'iban_hint'.tr(context),
              onValueChanged: (String value) {
                _partner.name = value;
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitThirdStep() async {
    try {
      await PartnerService().savePartner(partner: _partner);

      ref.read(partnerProvider.notifier).refreshPartners();
      Navigator.of(context).pop();
      showToast(
          _partner.id == null
              ? 'suceess_add_partner'.tr(context)
              : 'suceess_edit_partner'.tr(context),
          ToastType.success);
    } catch (e) {
      Navigator.of(context).pop();
      showToast('error_try_again'.tr(context), ToastType.error);
    }
  }

  Widget _formNavigation(int currentStep) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: SecondaryButton(
            text: currentStep != 0 ? 'back'.tr(context) : 'close'.tr(context),
            onPressed: () {
              currentStep != 0 ? _backFormStep() : Navigator.of(context).pop();
            },
          ),
        ),
        const Gap(16),
        Expanded(
          child: PrimaryButton(
            text:
                currentStep == 2 ? 'save'.tr(context) : 'continue'.tr(context),
            asyncOnPressed: () async {
              await _nextFormStep();
            },
          ),
        ),
      ],
    );
  }
  //
}
