import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/pages/auth/register/widgets/step_indicator.dart';
import 'package:erp_frontend_v2/utils/extensions.dart';
import 'package:erp_frontend_v2/widgets/buttons/primary_button.dart';
import 'package:erp_frontend_v2/widgets/custom_radio_button.dart';
import 'package:erp_frontend_v2/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../routing/routes.dart';

class RegisterForm extends ConsumerStatefulWidget {
  const RegisterForm({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterFormState();
}

class _RegisterFormState extends ConsumerState<RegisterForm> {
  final GlobalKey<CustomTextFieldState> formKey1 =
      GlobalKey<CustomTextFieldState>();
  final companyCuiController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final companyNameController = TextEditingController();
  final addressController = TextEditingController();
  final countyController = TextEditingController();
  final cityController = TextEditingController();
  final vatPayerController = TextEditingController();
  final regNumberController = TextEditingController();
  final phoneController = TextEditingController();

  bool rememberMe = false;
  String errorText = 'error';

  int currentStep = 1;
  final _formsPageViewController = PageController();
  List _forms = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _forms = [
      PopScope(
        child: _firstStep(),
        onPopInvoked: (didPop) => Future.sync(onWillPop),
      ),
      PopScope(
        child: _secondStep(),
        onPopInvoked: (didPop) => Future.sync(onWillPop),
      ),
      PopScope(
        child: _thirdStep(),
        onPopInvoked: (didPop) => Future.sync(onWillPop),
      )
    ];
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        _formHeader(context),
        Gap(context.height02),
        Flexible(child: _formBody()),
        Gap(context.height02),
        _formNavigation(),
        if (currentStep == 1) Gap(context.height02),
        if (currentStep == 1) _formOptions(context),
        if (currentStep == 1) Gap(context.height05),
        if (currentStep == 1) FittedBox(child: _bottomForm(context)),
      ],
    );
  }

  Widget _formBody() {
    return IndexedStack(
      index: currentStep - 1,
      children: [
        _firstStep(),
        _secondStep(),
        _thirdStep(),
      ],
    );
  }

  void _nextFormStep() {
    if (currentStep == 1 && formKey1.currentState!.valid()) {
      _fetchCompanyData();
      setState(() {
        currentStep++;
      });
    } else if (currentStep == 2) {
      setState(() {
        currentStep++;
      });
    } else if (currentStep == 3) {
      print('done');
    }
  }

  void _backFormStep() {
    _formsPageViewController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  bool onWillPop() {
    if (_formsPageViewController.page!.round() ==
        _formsPageViewController.initialPage) return true;

    _formsPageViewController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );

    return false;
  }

  Widget _firstStep() {
    return CustomTextField(
      key: formKey1,
      labelText: 'company_cui'.tr(context),
      hintText: 'RO12345678',
      initialValue: companyCuiController.text,
      errorText: errorText,
      onValueChanged: (value) {
        setState(() {
          companyCuiController.text = value;
        });
      },
      customValidator: (p0) {
        if (_validateCompanyCif(p0) != null) {
          return true;
        }
        return false;
      },
      required: true,
    );
  }

  Widget _secondStep() {
    return SingleChildScrollView(
      child: Flexible(
        child: Form(
          child: Column(
            children: [
              CustomTextField(
                keyboardType: TextInputType.name,
                labelText: 'company_name'.tr(context),
                hintText: 'company_name'.tr(context),
                errorText: 'error_company_name'.tr(context),
                onValueChanged: (value) {
                  setState(() {
                    companyNameController.text = value;
                  });
                  return null;
                },
                required: true,
              ),
              Row(
                children: [
                  Flexible(
                    child: CustomTextField(
                      keyboardType: TextInputType.name,
                      labelText: 'cui'.tr(context),
                      hintText: 'RO12345678',
                      errorText: 'error_company_cui'.tr(context),
                      onValueChanged: (value) {
                        setState(() {
                          companyCuiController.text = value;
                        });
                        return null;
                      },
                      required: true,
                    ),
                  ),
                  Gap(context.width01),
                  Flexible(
                    child: CustomTextField(
                      keyboardType: TextInputType.name,
                      labelText: 'registry_nr'.tr(context),
                      hintText: 'registry_nr'.tr(context),
                      errorText: 'error_registry_nr'.tr(context),
                      onValueChanged: (value) {
                        setState(() {
                          regNumberController.text = value;
                        });
                        return null;
                      },
                      required: true,
                    ),
                  ),
                ],
              ),
              CustomTextField(
                keyboardType: TextInputType.name,
                labelText: 'address'.tr(context),
                hintText: 'address'.tr(context),
                errorText: 'error_address'.tr(context),
                onValueChanged: (value) {
                  setState(() {
                    addressController.text = value;
                  });
                  return null;
                },
                required: true,
              ),
              Row(
                children: [
                  Flexible(
                    child: CustomTextField(
                      keyboardType: TextInputType.name,
                      labelText: 'state'.tr(context),
                      hintText: 'ex_Bihor'.tr(context),
                      errorText: 'error_state'.tr(context),
                      onValueChanged: (value) {
                        setState(() {
                          countyController.text = value;
                        });
                        return null;
                      },
                      required: true,
                    ),
                  ),
                  Gap(context.width01),
                  Flexible(
                    child: CustomTextField(
                      keyboardType: TextInputType.name,
                      labelText: 'locality'.tr(context),
                      hintText: 'ex_locality'.tr(context),
                      errorText: 'error_locality'.tr(context),
                      onValueChanged: (value) {
                        setState(() {
                          cityController.text = value;
                        });
                        return null;
                      },
                      required: true,
                    ),
                  ),
                ],
              ),
              CustomRadioButton(
                errorText: 'error_vat_payer'.tr(context),
                text: "pay_TVA".tr(context),
                direction: Axis.horizontal,
                textStyle: CustomStyle.regular16(),
                groupValue: vatPayerController.text,
                options: const ['yes', 'no'],
                validator: (p0) {
                  if (p0 == null || vatPayerController.text.isEmpty) {
                    return 'error_vat_payer'.tr(context);
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    vatPayerController.text = value!;
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _thirdStep() {
    return SingleChildScrollView(
      child: Flexible(
        child: Form(
          child: Column(
            children: [
              CustomTextField(
                keyboardType: TextInputType.emailAddress,
                labelText: 'email'.tr(context),
                hintText: 'input_email'.tr(context),
                errorText: errorText,
                onValueChanged: (value) {
                  setState(() {
                    emailController.text = value;
                  });
                },
                required: true,
              ),
              CustomTextField(
                keyboardType: TextInputType.phone,
                labelText: 'phone'.tr(context),
                hintText: 'phone_placeholder'.tr(context),
                errorText: errorText,
                onValueChanged: (value) {
                  setState(() {
                    phoneController.text = value;
                  });
                },
                required: false,
              ),
              CustomTextField(
                keyboardType: TextInputType.phone,
                labelText: 'password'.tr(context),
                hintText: 'password_placeholder'.tr(context),
                errorText: errorText,
                onValueChanged: (value) {
                  setState(() {
                    passwordController.text = value;
                  });
                },
                required: true,
              ),
              CustomTextField(
                keyboardType: TextInputType.phone,
                labelText: 'password_confirmation'.tr(context),
                hintText: 'password_confirmation_placeholder'.tr(context),
                errorText: errorText,
                onValueChanged: (value) {
                  setState(() {
                    passwordController.text = value;
                  });
                },
                required: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column _formHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: context.deviceWidth > 400 ? null : context.width05,
              ),
              Gap(context.width01),
              Text('welcome_back'.tr(context),
                  style: CustomStyle.regular24(color: CustomColor.slate_500)),
            ],
          ),
        ),
        Gap(context.height02),
        StepIndicator(
          totalSteps: _forms.length,
          currentStep: currentStep,
        ),
        Gap(context.height02),
        FittedBox(
          child: Text('data_of_your_company'.tr(context),
              style: CustomStyle.regular32()),
        ),
        if (currentStep == 1)
          Text(
            'input_cui_code_and_we_automaticaly_fill_the_rest'.tr(context),
            style: CustomStyle.regular16(color: CustomColor.slate_500),
          )
        else if (currentStep == 2)
          Text(
            'checking_dates_and_edit_if_need'.tr(context),
            style: CustomStyle.regular16(color: CustomColor.slate_500),
          )
        else
          Text(
            'input_account_data_for_login'.tr(context),
            style: CustomStyle.regular16(color: CustomColor.slate_500),
          )
      ],
    );
  }

  Widget _formOptions(BuildContext context) {
    return FittedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _customLine(context),
              Text('or'.tr(context), style: CustomStyle.regular16()),
              _customLine(context),
            ],
          ),
          Gap(context.height01 * 0.2),
          InkWell(
            onTap: () => setState(() {
              currentStep = 2;
            }),
            child: Text(
              'input_data_manually'.tr(context),
              style: CustomStyle.labelSemibold14(isUnderline: true),
            ),
          ),
        ],
      ),
    );
  }

  Widget _customLine(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: context.height01),
      width: context.width03,
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: CustomColor.slate_300,
      ))),
    );
  }

  Widget _bottomForm(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('already_have_an_account'.tr(context),
            style: CustomStyle.regular16(color: CustomColor.slate_900)),
        Gap(context.width01),
        InkWell(
          onTap: () => context.goNamed(authenticationPageName),
          child: Text('back_to_login'.tr(context),
              style: CustomStyle.labelSemibold16(
                  color: CustomColor.textPrimary, isUnderline: true)),
        ),
      ],
    );
  }

  Widget _formNavigation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (currentStep != 1)
          Expanded(
            child: PrimaryButton(
              style: CustomStyle.secondaryElevatedButtonStyle,
              textStyle: CustomStyle.labelSemibold14(
                color: CustomColor.textPrimary,
              ),
              text: 'back'.tr(context),
              onPressed: () {
                if (currentStep > 1) {
                  setState(() {
                    currentStep--;
                  });
                  _backFormStep();
                }
              },
            ),
          ),
        if (currentStep != 1) Gap(context.width01),
        Expanded(
          child: PrimaryButton(
            style: CustomStyle.submitBlackButton,
            text: 'continue'.tr(context),
            onPressed: () {
              _nextFormStep();
            },
          ),
        ),
      ],
    );
  }

  String? _validateCompanyCif(String v) {
    String cif = v.toUpperCase();
    cif = cif.indexOf('RO') > -1 ? cif.substring(2) : cif;
    cif = cif.replaceAll(RegExp(r'\s'), '');

    if (cif.length < 2 || cif.length > 10) {
      return 'Lungimea corectă fără RO, este între 2 și 10 caractere!';
    }

    if (int.tryParse(cif) == null) {
      return 'Nu este număr!';
    }

    const testKey = '753217532';
    final controlNumber = int.parse(cif.substring(cif.length - 1));
    cif = cif.substring(0, cif.length - 1);

    while (cif.length != testKey.length) {
      cif = '0' + cif;
    }

    int sum = 0;
    int i = cif.length;

    while (i-- > 0) {
      sum = sum + int.parse(cif[i]) * int.parse(testKey[i]);
    }

    int calculatedControlNumber = (sum * 10) % 11;

    if (calculatedControlNumber == 10) {
      calculatedControlNumber = 0;
    }

    if (controlNumber != calculatedControlNumber) {
      return 'CIF invalid!';
    }
    return null;
  }

  void _fetchCompanyData() {
    // fetch data
  }
}
