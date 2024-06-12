import 'package:erp_frontend_v2/boxes.dart';
import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/models/user/user.dart' as custom_user;
import 'package:erp_frontend_v2/routing/routes.dart';
import 'package:erp_frontend_v2/services/user.dart';
import 'package:erp_frontend_v2/utils/extensions.dart';
import 'package:erp_frontend_v2/widgets/buttons/primary_button.dart';
import 'package:erp_frontend_v2/widgets/buttons/tertiary_button.dart';
import 'package:erp_frontend_v2/widgets/custom_checkbox.dart';
import 'package:erp_frontend_v2/widgets/custom_text_field_1.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      _signInWithEmailAndPassword(
          emailController.text, passwordController.text);
    } else {}
  }

  Future<void> _signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = credential.user!;

      custom_user.User? user = await _fetchUser(firebaseUser.uid);

      if (user != null) {
        boxUser.put('user', user);
        context.go(overviewPageRoute);
      } else {
        print('No user found in the database.');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      } else if (e.code == 'invalid-credential') {
        print('Invalid Credentials');
      }
    } catch (e) {
      print('An unexpected error occurred: $e');
    }
  }

  Future<custom_user.User?> _fetchUser(String userId) async {
    try {
      final userService = UserService();
      final user = await userService.getUser(userId);
      return user;
    } catch (error) {
      return null; // Return null in case of an error
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
        if (context.deviceWidth > largeScreenSize) const Spacer(),
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
                  emailController.text = value;
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
                  passwordController.text = value;
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
          )
        ],
      ),
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
