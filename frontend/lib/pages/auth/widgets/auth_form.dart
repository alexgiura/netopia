import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/utils/extensions.dart';
import 'package:erp_frontend_v2/widgets/buttons/primary_button.dart';
import 'package:erp_frontend_v2/widgets/custom_checkbox.dart';
import 'package:erp_frontend_v2/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class AuthForm extends ConsumerStatefulWidget {
  const AuthForm({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthFormState();
}

class _AuthFormState extends ConsumerState<AuthForm> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool rememberMe = false;

  void _submit() {
    if (formKey.currentState!.validate()) {
      print('Form is invalid');
    } else {
      print('Form is valid');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                _formHeader(context),
                Gap(context.height02),
                CustomTextField(
                  keyboardType: TextInputType.emailAddress,
                  labelText: 'email'.tr(context),
                  hintText: 'input_email'.tr(context),
                  errorText: 'error_email'.tr(context),
                  onValueChanged: (value) {
                    setState(() {
                      emailController.text = value;
                    });
                  },
                  required: true,
                ),
                Gap(context.height02),
                CustomTextField(
                  keyboardType: TextInputType.visiblePassword,
                  expand: false,
                  labelText: 'password'.tr(context),
                  hintText: 'input_password'.tr(context),
                  errorText: 'error_password'.tr(context),
                  obscureText: true,
                  onValueChanged: (value) {
                    setState(() {
                      passwordController.text = value;
                    });
                  },
                  required: true,
                ),
                Gap(context.height01),
                _formOptions(context),
                Gap(context.height05),
                Align(
                  alignment: Alignment.center,
                  child: PrimaryButton(
                    text: 'login'.tr(context),
                    onPressed: () => _submit(),
                  ),
                )
              ],
            ),
            Gap(context.height04),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('dont_have_account'.tr(context),
                    style: CustomStyle.regular16()),
                const Gap(4),
                InkWell(
                  onTap: () {},
                  child: Text('create_account'.tr(context),
                      style: CustomStyle.labelSemibold16()),
                ),
              ],
            ),
          ],
        ));
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
        Text(
          'login'.tr(context),
          style: CustomStyle.regular32(),
        ),
        Text(
          'input_your_account_data'.tr(context),
          style: CustomStyle.regular16(color: CustomColor.slate_500),
        )
      ],
    );
  }

  Widget _formOptions(BuildContext context) {
    return context.deviceWidth < 400
        ? FittedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CustomCheckbox(
                      value: rememberMe,
                      onChanged: (val) => setState(() => rememberMe = val),
                    ),
                    Gap(context.width01),
                    Text(
                      'remember_me'.tr(context),
                      style: CustomStyle.labelSemibold14(),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {},
                  child: Text(
                    'forgot_password'.tr(context),
                    style: CustomStyle.labelSemibold14(),
                  ),
                ),
              ],
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CustomCheckbox(
                    value: rememberMe,
                    onChanged: (val) => setState(() => rememberMe = val),
                  ),
                  Gap(context.width01),
                  Text(
                    'remember_me'.tr(context),
                    style: CustomStyle.labelSemibold14(),
                  ),
                ],
              ),
              InkWell(
                onTap: () {},
                child: Text(
                  'forgot_password'.tr(context),
                  style: CustomStyle.labelSemibold14(),
                ),
              ),
            ],
          );
  }
}
