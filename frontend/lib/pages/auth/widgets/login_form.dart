import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/models/user/user.dart' as custom_user;
import 'package:erp_frontend_v2/providers/user_provider.dart';
import 'package:erp_frontend_v2/routing/routes.dart';
import 'package:erp_frontend_v2/services/user.dart';
import 'package:erp_frontend_v2/utils/extensions.dart';
import 'package:erp_frontend_v2/widgets/buttons/primary_button.dart';
import 'package:erp_frontend_v2/widgets/buttons/tertiary_button.dart';
import 'package:erp_frontend_v2/widgets/custom_checkbox.dart';
import 'package:erp_frontend_v2/widgets/custom_text_field_1.dart';
import 'package:erp_frontend_v2/widgets/dialog_widgets/custom_toast.dart';
import 'package:erp_frontend_v2/widgets/dialog_widgets/warning_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../utils/util_functions.dart';
import '../../../utils/responsiveness.dart';

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
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool rememberMe = false;
  final FocusNode _focusNode = FocusNode();

  String? passwordError;
  String? emailError;
  String? tooManyRequestsError;

  Future<void> _signInWithEmailAndPassword(
      String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emailError = 'user_not_found'.tr(context);
      } else if (e.code == 'wrong-password') {
        passwordError = 'wrong_password'.tr(context);
      } else if (e.code == 'invalid-credential') {
        passwordError = 'invalid_credential'.tr(context);
      } else if (e.code == 'too-many-requests') {
        setState(() {
          tooManyRequestsError = 'too_many_requests'.tr(context);
        });
      }
    } catch (e) {
      emailError = 'user_not_found'.tr(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _formHeader(context),
          Gap(context.height02),
          _formBody(context),
          Gap(context.height02),
          _formOptions(context),
          Gap(context.height02),
          _formButton(context),
          Gap(context.height02),
          FittedBox(child: _formBottom(context)),
        ],
      ),
    );
  }

  Widget _formBody(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: (event) async {
        if (event.logicalKey == LogicalKeyboardKey.enter) {
          if (formKey.currentState!.validate()) {
            await _signInWithEmailAndPassword(
                emailController.text, passwordController.text);
          }
        }
      },
      child: Form(
        key: formKey,
        child: Column(
          children: [
            CustomTextField1(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'error_required_field'.tr(context);
                } else {
                  if (emailError != null) {
                    return emailError;
                  }
                  return validateEmail(context, value);
                }
              },
              keyboardType: TextInputType.emailAddress,
              labelText: 'email'.tr(context),
              hintText: 'input_email'.tr(context),
              onValueChanged: (value) {
                emailError = null;
                emailController.text = value;
              },
              required: true,
            ),
            Gap(context.height01),
            CustomTextField1(
              keyboardType: TextInputType.visiblePassword,
              labelText: 'password'.tr(context),
              hintText: 'input_password'.tr(context),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'error_required_field'.tr(context);
                }
                if (passwordError != null) {
                  return passwordError;
                }
                return null;
              },
              obscureText: true,
              onValueChanged: (value) {
                passwordError = null;
                passwordController.text = value;
              },
              required: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _formButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: PrimaryButton(
        style: CustomStyle.submitBlackButton,
        text: 'login'.tr(context),
        asyncOnPressed: () async {
          if (formKey.currentState!.validate()) {
            await _signInWithEmailAndPassword(
                emailController.text, passwordController.text);
          }
        },
      ),
    );
  }

  Widget _formHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/logo_icon.png',
              width: 30,
              color: CustomColor.slate_500,
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
        ),
        if (tooManyRequestsError != null)
          Text(
            tooManyRequestsError.toString(),
            style: CustomStyle.errorText,
          )
      ],
    );
  }

  Widget _formOptions(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return constraints.maxWidth > 240
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomCheckbox(
                    labelText: 'remember_me'.tr(context),
                    value: rememberMe,
                    onChanged: (val) => setState(() => rememberMe = val),
                  ),
                  TertiaryButton(
                    underline: true,
                    text: 'forgot_password'.tr(context),
                    onPressed: () {},
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('dont_have_account'.tr(context), style: CustomStyle.regular16()),
        const Gap(4),
        TertiaryButton(
            text: 'register_your_company'.tr(context),
            onPressed: widget.changeForm),
      ],
    );
  }
}
