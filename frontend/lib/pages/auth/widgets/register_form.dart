import 'package:erp_frontend_v2/boxes.dart';
import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/models/company/company_model.dart';
import 'package:erp_frontend_v2/models/user/user.dart' as custom_user;
import 'package:erp_frontend_v2/pages/auth/widgets/step_indicator.dart';
import 'package:erp_frontend_v2/providers/user_provider.dart';
import 'package:erp_frontend_v2/routing/routes.dart';
import 'package:erp_frontend_v2/services/company.dart';
import 'package:erp_frontend_v2/services/user.dart';
import 'package:erp_frontend_v2/utils/extensions.dart';
import 'package:erp_frontend_v2/utils/util_functions.dart';
import 'package:erp_frontend_v2/widgets/buttons/primary_button.dart';
import 'package:erp_frontend_v2/widgets/buttons/secondary_button.dart';
import 'package:erp_frontend_v2/widgets/custom_radio_button.dart';
import 'package:erp_frontend_v2/widgets/custom_text_field.dart';
import 'package:erp_frontend_v2/widgets/custom_text_field_1.dart';
import 'package:erp_frontend_v2/widgets/dialog_widgets/custom_toast.dart';
import 'package:erp_frontend_v2/widgets/dialog_widgets/warning_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class RegisterForm extends ConsumerStatefulWidget {
  final void Function() changeForm;
  const RegisterForm({required this.changeForm, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterFormState();
}

class _RegisterFormState extends ConsumerState<RegisterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final GlobalKey<CustomTextFieldState> formKey1 =
      GlobalKey<CustomTextFieldState>();
  final companyTaxIdController = TextEditingController();
  bool errorCompanyTaxId = false;

  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();

  final vatPayerController = TextEditingController();

  bool rememberMe = false;

  int currentStep = 0;

  @override
  void initState() {
    super.initState();
  }

  Future<custom_user.User?> _saveUser(custom_user.User user) async {
    try {
      final userService = UserService();
      custom_user.User? result = await userService.saveUser(user);
      return result;
    } catch (error) {
      if (error.toString().contains('Email address already exists')) {
        WarningCustomDialog(
          title: 'email_already_registered_title'.tr(context),
          subtitle: 'email_already_registered_subtitle'.tr(context),
          primaryButtonText: 'back_to_Login'.tr(context),
          primaryButtonAction: () {
            widget.changeForm();
            Navigator.of(context).pop();
          },
          secondaryButtonText: 'close'.tr(context),
          secondaryButtonAction: () {
            Navigator.of(context).pop();
          },
        );
      } else {
        showToast('error'.tr(context), ToastType.error);
      }
    }
  }

  Future<Company?> _getCompanyByTaxId(String taxId) async {
    try {
      final companyService = CompanyService();
      Company? result = await companyService.getCompanyByTaxId(taxId);

      if (result != null) {
        if (context.mounted) {
          errorCompanyTaxId = false;
          formKey1.currentState!.valid();
        }
        return result;
      } else {
        if (context.mounted) {
          errorCompanyTaxId = true;
          formKey1.currentState!.valid();
        }
        return null;
      }
    } catch (error) {
      if (error.toString().contains('InvalidTaxId')) {
        if (context.mounted) {
          errorCompanyTaxId = true;
          formKey1.currentState!.valid();
        }
      }
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    List _forms = [_firstStep(), _secondStep(), _thirdStep()];

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        _formHeader(context, _forms),
        Gap(context.height02),
        Flexible(child: _formBody()),
        Gap(context.height02),
        _formNavigation(currentStep),
        if (currentStep == 0) Gap(context.height02),
        if (currentStep == 0) _formOptions(context),
        if (currentStep == 0) Gap(context.height05),
        if (currentStep == 0) FittedBox(child: _bottomForm(context)),
      ],
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

  // First Step
  Widget _firstStep() {
    return CustomTextField(
      key: formKey1,
      validator: (value) {
        if (value!.isEmpty) {
          return 'error_required_field'.tr(context);
        } else {
          if (errorCompanyTaxId) {
            return 'wrong_company_vat_number'.tr(context);
          }
          return validateCompanyCif(context, value);
        }
      },
      borderVisible: true,
      keyboardType: TextInputType.text,
      labelText: 'company_vat_number'.tr(context),
      hintText: 'RO12345678',
      onValueChanged: (value) {
        companyTaxIdController.text = value;
      },
      required: true,
    );
  }

  Future<void> _submitFirstStep() async {
    errorCompanyTaxId = false;
    if (formKey1.currentState!.valid()) {
      Company? company = await _getCompanyByTaxId(companyTaxIdController.text);
      if (company != null && !errorCompanyTaxId) {
        ref.read(userProvider.notifier).updateUserField('company', company);
        if (mounted) {
          setState(() {
            currentStep++;
          });
        }
      }
    }
  }

// Second Step
  Widget _secondStep() {
    return SingleChildScrollView(
      child: Container(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField1(
                initialValue: ref.read(userProvider).company?.name ?? '',
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'error_required_field'.tr(context);
                  }
                  return null;
                },
                keyboardType: TextInputType.name,
                labelText: 'company_name'.tr(context),
                hintText: 'company_name'.tr(context),
                onValueChanged: (value) {
                  ref
                      .read(userProvider.notifier)
                      .updateUserField('company.name', value);
                },
                required: true,
              ),
              Row(
                children: [
                  Flexible(
                    child: CustomTextField1(
                      initialValue:
                          ref.read(userProvider).company?.vatNumber ?? '',
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'error_required_field'.tr(context);
                        } else {
                          if (errorCompanyTaxId) {
                            return 'code_validation_failed'.tr(context);
                          }
                          return validateCompanyCif(context, value);
                        }
                      },
                      keyboardType: TextInputType.name,
                      labelText: 'vat_number'.tr(context),
                      hintText: 'RO12345678',
                      onValueChanged: (value) {
                        ref
                            .read(userProvider.notifier)
                            .updateUserField('company.vatNumber', value);
                      },
                      required: true,
                    ),
                  ),
                  Gap(context.width01),
                  Flexible(
                    child: CustomTextField1(
                      initialValue:
                          ref.read(userProvider).company?.registrationNumber ??
                              '',
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'error_required_field'.tr(context);
                        }
                        return null;
                      },
                      keyboardType: TextInputType.name,
                      labelText: 'registry_nr'.tr(context),
                      hintText: 'registry_nr'.tr(context),
                      onValueChanged: (value) {
                        ref.read(userProvider.notifier).updateUserField(
                            'company.registrationNumber', value);
                      },
                      required: true,
                    ),
                  ),
                ],
              ),
              CustomTextField1(
                initialValue:
                    ref.read(userProvider).company?.address?.address ?? '',
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'error_required_field'.tr(context);
                  }
                  return null;
                },
                keyboardType: TextInputType.name,
                labelText: 'address'.tr(context),
                hintText: 'address'.tr(context),
                onValueChanged: (value) {
                  ref
                      .read(userProvider.notifier)
                      .updateUserField('company.address.address', value);
                },
                required: true,
              ),
              Row(
                children: [
                  Flexible(
                    child: CustomTextField1(
                      initialValue:
                          ref.read(userProvider).company?.address?.countyCode ??
                              '',
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'error_required_field'.tr(context);
                        }
                        if (RegExp(r'^[0-9]').hasMatch(value)) {
                          return 'state_format_error'.tr(context);
                        }
                        return null;
                      },
                      keyboardType: TextInputType.name,
                      labelText: 'state'.tr(context),
                      hintText: 'ex_Bihor'.tr(context),
                      onValueChanged: (value) {
                        ref.read(userProvider.notifier).updateUserField(
                            'company.address.countyCode', value);
                      },
                      required: true,
                    ),
                  ),
                  Gap(context.width01),
                  Flexible(
                    child: CustomTextField1(
                      initialValue:
                          ref.read(userProvider).company?.address?.locality ??
                              '',
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'error_required_field'.tr(context);
                        }
                        // if value start with number return error
                        if (RegExp(r'^[0-9]').hasMatch(value)) {
                          return 'locality_format_error'.tr(context);
                        }
                        return null;
                      },
                      keyboardType: TextInputType.name,
                      labelText: 'locality'.tr(context),
                      hintText: 'ex_locality'.tr(context),
                      onValueChanged: (value) {
                        ref
                            .read(userProvider.notifier)
                            .updateUserField('company.address.locality', value);
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

  Future<void> _submitSecondStep() async {
    if (_formKey.currentState!.validate()) {
      try {
        final company = await CompanyService().getCompany(
          ref.read(userProvider).company?.vatNumber,
        );
        if (company == null) {
          if (mounted) {
            setState(() {
              currentStep++;
            });
          }
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return WarningCustomDialog(
                title: 'vat_number_already_registered_title'.tr(context),
                subtitle: 'vat_number_already_registered_subtitle'.tr(context),
                primaryButtonText: 'back_to_Login'.tr(context),
                primaryButtonAction: () {
                  widget.changeForm();
                  Navigator.of(context).pop();
                },
                secondaryButtonText: 'close'.tr(context),
                secondaryButtonAction: () {
                  Navigator.of(context).pop();
                },
              );
            },
          );
        }
      } catch (error) {
        showToast('error'.tr(context), ToastType.error);
      }
    }
  }

// Third Step
  Widget _thirdStep() {
    return SingleChildScrollView(
      child: Container(
        child: Form(
          key: _formKey2,
          child: Column(
            children: [
              CustomTextField1(
                keyboardType: TextInputType.emailAddress,
                labelText: 'email'.tr(context),
                hintText: 'input_email'.tr(context),
                onValueChanged: (value) {
                  ref
                      .read(userProvider.notifier)
                      .updateUserField('email', value);
                },
                required: true,
              ),
              CustomTextField1(
                keyboardType: TextInputType.phone,
                labelText: 'phone'.tr(context),
                hintText: 'phone_placeholder'.tr(context),
                onValueChanged: (value) {
                  ref
                      .read(userProvider.notifier)
                      .updateUserField('phoneNumber', value);
                },
                required: false,
              ),
              CustomTextField1(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'error_password'.tr(context);
                  } else {
                    if (passwordController.text !=
                            passwordConfirmationController.text &&
                        passwordConfirmationController.text.isNotEmpty) {
                      return 'error_password_confirmation_match'.tr(context);
                    }
                    return validatePassword(context, value);
                  }
                },
                keyboardType: TextInputType.visiblePassword,
                labelText: 'password'.tr(context),
                hintText: 'password_placeholder'.tr(context),
                obscureText: true,
                onValueChanged: (value) {
                  passwordController.text = value;
                },
                required: true,
              ),
              CustomTextField1(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'error_password'.tr(context);
                  } else {
                    if (passwordController.text !=
                        passwordConfirmationController.text) {
                      return 'error_password_confirmation_match'.tr(context);
                    }
                    return validatePassword(context, value);
                  }
                },
                keyboardType: TextInputType.visiblePassword,
                labelText: 'password_confirmation'.tr(context),
                hintText: 'password_confirmation_placeholder'.tr(context),
                obscureText: true,
                onValueChanged: (value) {
                  passwordConfirmationController.text = value;
                },
                required: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitThirdStep() async {
    if (_formKey.currentState!.validate()) {
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: ref.read(userProvider).email!,
          password: passwordController.text,
        );

        if (credential.user != null) {
          ref
              .read(userProvider.notifier)
              .updateUserField('id', credential.user!.uid);
          final updatedUser = ref.read(userProvider);

          try {
            // Save user in DB
            custom_user.User? result = await _saveUser(updatedUser);
            if (result != null) {
              boxUser.put('user', result);
              if (context.mounted) {
                context.go(overviewPageRoute);
              }
            } else {
              await credential.user!.delete();
            }
          } catch (e) {
            await credential.user!.delete();
          }
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return WarningCustomDialog(
                title: 'email_already_registered_title'.tr(context),
                subtitle: 'email_already_registered_subtitle'.tr(context),
                primaryButtonText: 'back_to_Login'.tr(context),
                primaryButtonAction: () {
                  widget.changeForm();
                  Navigator.of(context).pop();
                },
                secondaryButtonText: 'close'.tr(context),
                secondaryButtonAction: () {
                  Navigator.of(context).pop();
                },
              );
            },
          );
        } else {
          showToast('error'.tr(context), ToastType.error);
        }
      }
    }
  }

  Column _formHeader(BuildContext context, List<dynamic> forms) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/logo_icon.png',
                color: CustomColor.slate_500,
                width: 30,
              ),
              Text('welcome'.tr(context),
                  style: CustomStyle.regular24(color: CustomColor.slate_500)),
            ],
          ),
        ),
        Gap(context.height02),
        StepIndicator(
          totalSteps: forms.length,
          currentStep: currentStep,
        ),
        Gap(context.height02),
        FittedBox(
          child: Text('data_of_your_company'.tr(context),
              style: CustomStyle.regular32()),
        ),
        if (currentStep == 0)
          Text(
            'input_vat_number_and_we_automaticaly_fill_the_rest'.tr(context),
            style: CustomStyle.regular16(color: CustomColor.slate_500),
          )
        else if (currentStep == 1)
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
              currentStep++;
            }),
            child: Text(
              'input_data_manually'.tr(context),
              style: CustomStyle.semibold14(isUnderline: true),
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
          onTap: widget.changeForm,
          child: Text('back_to_login'.tr(context),
              style: CustomStyle.semibold16(
                  color: CustomColor.textPrimary, isUnderline: true)),
        ),
      ],
    );
  }

  Widget _formNavigation(int currentStep) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (currentStep != 0)
          Expanded(
            child: SecondaryButton(
              buttonStyle: CustomStyle.secondaryElevatedButtonStyle,
              text: 'back'.tr(context),
              onPressed: () {
                if (currentStep > 0) {
                  _backFormStep();
                }
              },
            ),
          ),
        if (currentStep != 0) Gap(context.width01),
        Expanded(
          child: PrimaryButton(
            style: CustomStyle.submitBlackButton,
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
}
