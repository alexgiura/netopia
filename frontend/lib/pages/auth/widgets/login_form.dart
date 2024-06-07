import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/routing/routes.dart';
import 'package:erp_frontend_v2/utils/extensions.dart';
import 'package:erp_frontend_v2/widgets/buttons/primary_button.dart';
import 'package:erp_frontend_v2/widgets/buttons/tertiary_button.dart';
import 'package:erp_frontend_v2/widgets/custom_checkbox.dart';
import 'package:erp_frontend_v2/widgets/custom_text_field_1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../utils/util_functions.dart';
import '../../../helpers/responsiveness.dart';

class LoginForm extends ConsumerStatefulWidget {
  final void Function() changeForm;
  const LoginForm({
    required this.changeForm,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool rememberMe = false;

  void _submit() {
    if (formKey.currentState!.validate()) {
      context.go(overviewPageRoute);
    } else {
      debugPrint('Form is invalid');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        _formHeader(context),
        Gap(context.height02),
        _formBody(context),
        Gap(context.height02),
        _formOptions(context),
        Gap(context.height02),
        _formButton(context),
        if (context.deviceWidth > largeScreenSize) Spacer(),
        FittedBox(child: _formBottom(context)),
      ],
    );
  }

  Widget _formBody(BuildContext context) {
    return SingleChildScrollView(
      child: Flexible(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              CustomTextField1(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'error_email'.tr(context);
                  } else {
                    return isValidEmail(value)
                        ? null
                        : 'error_email_format'.tr(context);
                  }
                },
                borderVisible: true,
                keyboardType: TextInputType.emailAddress,
                labelText: 'email'.tr(context),
                hintText: 'input_email'.tr(context),
                onValueChanged: (value) {
                  setState(() {
                    emailController.text = value;
                  });
                },
                required: true,
              ),
              Gap(context.height01),
              CustomTextField1(
                keyboardType: TextInputType.visiblePassword,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                labelText: 'password'.tr(context),
                hintText: 'input_password'.tr(context),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'error_password'.tr(context);
                  } else {
                    return validatePassword(context, value);
                  }
                },
                obscureText: true,
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

  SizedBox _formButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: PrimaryButton(
        style: CustomStyle.submitBlackButton,
        text: 'login'.tr(context),
        onPressed: () => _submit(),
      ),
    );
  }

  Widget _formHeader(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 30,
              ),
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
      ),
    );
  }

  Widget _formOptions(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return constraints.maxWidth > 240
            ? // valoare arbitrară; ajustează în funcție de nevoi
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: CustomCheckbox(
                      labelText: 'remember_me'.tr(context),
                      value: rememberMe,
                      onChanged: (val) => setState(() => rememberMe = val),
                    ),
                  ),
                  Flexible(
                    child: TertiaryButton(
                      text: 'forgot_password'.tr(context),
                      onPressed: () {},
                    ),
                  ),
                ],
              )
            : Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.spaceBetween,
                children: [
                  CustomCheckbox(
                    labelText: 'remember_me'.tr(context),
                    value: rememberMe,
                    onChanged: (val) => setState(() => rememberMe = val),
                  ),
                  TertiaryButton(
                    text: 'forgot_password'.tr(context),
                    onPressed: () {},
                  ),
                ],
              );
      },
    );
  }

  Widget _formBottom(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text('dont_have_account'.tr(context), style: CustomStyle.regular16()),
          const Gap(4),
          TertiaryButton(
              text: 'register_your_company'.tr(context),
              onPressed: widget.changeForm),
        ],
      ),
    );
  }
}
