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

final currentStepRegister = StateProvider<int>((ref) => 1);

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
  String errorText = 'error';

  final _formsPageViewController = PageController();
  List _forms = [];

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
      //popup
      print(error);
      return null;
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

  Future<String?> _createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return credential.user?.uid;
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
              },
              secondaryButtonText: 'close'.tr(context),
              secondaryButtonAction: () {
                Navigator.of(context).pop();
              },
            );
          },
        );
      }
    } catch (e) {
      //popup
      print('An unexpected error occurred: $e');
    }

    return null;
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

    final currentStep = ref.watch(currentStepRegister);
    // final currentUser = ref.watch(userProvider);

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        _formHeader(context, currentStep),
        Gap(context.height02),
        Flexible(child: _formBody(currentStep)),
        Gap(context.height02),
        _formNavigation(currentStep),
        if (currentStep == 1) Gap(context.height02),
        if (currentStep == 1) _formOptions(context, currentStep),
        if (currentStep == 1) Gap(context.height05),
        if (currentStep == 1) FittedBox(child: _bottomForm(context)),
      ],
    );
  }

  Widget _formBody(int currentStep) {
    return IndexedStack(
      index: currentStep - 1,
      children: [
        _firstStep(),
        _secondStep(),
        _thirdStep(),
      ],
    );
  }

  Future<void> _nextFormStep(int currentStep) async {
    if (currentStep == 1) {
      await _submitFirstStep();
    } else if (currentStep == 2) {
      await _submitSecondStep();
    } else if (currentStep == 3) {
      await _submitThirdStep();
    }
  }

  void _backFormStep(int currentStep) {
    if (currentStep > 1) {
      ref.read(currentStepRegister.notifier).state--;
      _formsPageViewController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
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

  // First Step
  Widget _firstStep() {
    return CustomTextField(
      key: formKey1,
      validator: (value) {
        if (value!.isEmpty) {
          return 'error_required_field'.tr(context);
        } else {
          if (errorCompanyTaxId) {
            return 'code_validation_failed'.tr(context);
          }
          return validateCompanyCif(value);
        }
      },
      borderVisible: true,
      keyboardType: TextInputType.emailAddress,
      labelText: 'company_cui'.tr(context),
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
        ref.read(currentStepRegister.notifier).state++;
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
                // errorText: 'error_company_name'.tr(context),
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
                          return validateCompanyCif(value);
                        }
                      },
                      keyboardType: TextInputType.name,
                      labelText: 'cui'.tr(context),
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
      ref.read(currentStepRegister.notifier).state++;
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
                        passwordConfirmationController.text) {
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
                  setState(() {
                    passwordController.text = value;
                  });
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
                  setState(() {
                    passwordConfirmationController.text = value;
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

  Future<void> _submitThirdStep() async {
    if (_formKey.currentState!.validate()) {
      // Create Firebase user
      String? userId = await _createUserWithEmailAndPassword(
          ref.read(userProvider).email!, passwordController.text);
      if (userId != null) {
        ref.read(userProvider.notifier).updateUserField('id', userId);
        // Trebuie updatat din radio button
        ref.read(userProvider.notifier).updateUserField('company.vat', true);

        // Save user in DB
        custom_user.User? result = await _saveUser(ref.read(userProvider));
        if (result != null) {
          boxUser.put('user', result);
          if (mounted) {
            context.go(overviewPageRoute);
          }
        }
      }
    }
  }

  Column _formHeader(BuildContext context, int currentStep) {
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

  Widget _formOptions(BuildContext context, int currentStep) {
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
            onTap: () => ref.read(currentStepRegister.notifier).state++,
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
        if (currentStep != 1)
          Expanded(
            child: SecondaryButton(
              buttonStyle: CustomStyle.secondaryElevatedButtonStyle,
              text: 'back'.tr(context),
              onPressed: () {
                if (currentStep > 1) {
                  _backFormStep(currentStep);
                }
              },
            ),
          ),
        if (currentStep != 1) Gap(context.width01),
        Expanded(
          child: PrimaryButton(
            style: CustomStyle.submitBlackButton,
            text:
                currentStep == 3 ? 'save'.tr(context) : 'continue'.tr(context),
            asyncOnPressed: () async {
              await _nextFormStep(currentStep);
            },
          ),
        ),
      ],
    );
  }
}
