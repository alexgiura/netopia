import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/pages/auth/register/widgets/step_indicator.dart';
import 'package:erp_frontend_v2/utils/extensions.dart';
import 'package:erp_frontend_v2/widgets/buttons/primary_button.dart';
import 'package:erp_frontend_v2/widgets/buttons/secondary_button.dart';
import 'package:erp_frontend_v2/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class RegisterForm extends ConsumerStatefulWidget {
  const RegisterForm({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterFormState();
}

class _RegisterFormState extends ConsumerState<RegisterForm> {
  final formKey = GlobalKey<FormState>();
  final companyCifController = TextEditingController();
  final passwordController = TextEditingController();
  final companyNameController = TextEditingController();
  final addressController = TextEditingController();
  final countyController = TextEditingController();
  final cityController = TextEditingController();
  final vatPayerController = TextEditingController();
  final regNumberController = TextEditingController();

  bool rememberMe = false;
  String errorText = 'error_company_cif';
  int currentStep = 1;
  final _formsPageViewController = PageController();
  List _forms = [];

  void _submit() {
    if (!_validateCompanyCif(companyCifController.text)) {
      print('Form is invalid');
    } else {
      print('Form is valid');
    }
  }

  @override
  Widget build(BuildContext context) {
    _forms = [
      WillPopScope(
        onWillPop: () => Future.sync(onWillPop),
        child: _firstStep(),
      ),
      WillPopScope(
        onWillPop: () => Future.sync(onWillPop),
        child: _secondStep(),
      ),
      WillPopScope(
        onWillPop: () => Future.sync(onWillPop),
        child: _thirdStep(),
      ),
    ];
    return Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                children: [
                  _formHeader(context),
                  Gap(context.height02),
                  _formBody(),
                  Align(
                    alignment: Alignment.center,
                    child: _formNavigation(),
                  ),
                  Gap(context.height03),
                  _formOptions(context),
                ],
              ),
            ),
            _bottomForm(context)
          ],
        ));
  }

  Widget _formBody() {
    return Flexible(
      child: PageView.builder(
        controller: _formsPageViewController,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return _forms[index];
        },
      ),
    );
  }

  void _nextFormStep() {
    _formsPageViewController.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void _backFormStep() {
    _formsPageViewController.previousPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  bool onWillPop() {
    if (_formsPageViewController.page!.round() ==
        _formsPageViewController.initialPage) return true;

    _formsPageViewController.previousPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );

    return false;
  }

  Widget _firstStep() {
    return CustomTextField(
      keyboardType: TextInputType.emailAddress,
      labelText: 'company_cif'.tr(context),
      hintText: '12345678',
      initialValue: companyCifController.text,
      errorText: errorText,
      onValueChanged: (value) {
        setState(() {
          companyCifController.text = value;
        });
        return _validateCompanyCif(value);
      },
      isCIFField: true,
      required: true,
    );
  }

  Widget _secondStep() {
    return IntrinsicHeight(
      child: Column(
        children: [
          CustomTextField(
            keyboardType: TextInputType.name,
            labelText: 'company_name',
            hintText: 'company_name'.tr(context),
            errorText: 'error_company_name',
            onValueChanged: (value) {
              setState(() {
                companyNameController.text = value;
              });
              return null;
            },
            required: true,
          ),
          CustomTextField(
            keyboardType: TextInputType.name,
            labelText: 'company_name',
            hintText: 'company_name'.tr(context),
            errorText: 'error_company_name',
            onValueChanged: (value) {
              setState(() {
                companyNameController.text = value;
              });
              return null;
            },
            required: true,
          ),
        ],
      ),
    );
  }

  Widget _thirdStep() {
    return CustomTextField(
      keyboardType: TextInputType.emailAddress,
      labelText: 'third',
      hintText: '12345678',
      errorText: errorText,
      onValueChanged: (value) {
        setState(() {
          companyCifController.text = value;
        });
        return _validateCompanyCif(value);
      },
      isCIFField: true,
      required: true,
    );
  }

  Column _formHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
        Gap(context.height02),
        StepIndicator(
          totalSteps: _forms.length,
          currentStep: currentStep,
        ),
        Gap(context.height02),
        Text(
          'data_of_your_company'.tr(context),
          style: CustomStyle.regular32(),
        ),
        Text(
          'input_cif_code_and_we_automaticaly_fill_the_rest'.tr(context),
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
            onTap: () {},
            child: Text(
              'input_data_manually'.tr(context),
              style: CustomStyle.labelSemibold14(),
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
      decoration: BoxDecoration(
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
        Gap(context.width01 * 0.2),
        Text('back_to_login'.tr(context),
            style: CustomStyle.labelSemibold16(color: CustomColor.textPrimary)),
      ],
    );
  }

  Widget _formNavigation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (currentStep != 1)
          Expanded(
            child: SecondaryButton(
              text: 'Înapoi',
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
            text: 'continue'.tr(context),
            onPressed: () {
              if (currentStep < _forms.length) {
                setState(() {
                  currentStep++;
                });
                _nextFormStep();
              }
            },
          ),
        ),
      ],
    );
  }

  bool _validateCompanyCif(String v) {
    String cif = v.toUpperCase();
    cif = cif.indexOf('RO') > -1 ? cif.substring(2) : cif;
    cif = cif.replaceAll(RegExp(r'\s'), '');

    if (cif.length < 2 || cif.length > 10) {
      setState(() {
        errorText = 'Lungimea corectă fără RO, este între 2 și 10 caractere!';
      });
      return false;
    }

    if (int.tryParse(cif) == null) {
      setState(() {
        errorText = 'Nu este număr!';
      });
      return false;
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
      setState(() {
        errorText = 'CIF invalid!';
      });
      return false;
    }
    return true;
  }
}
