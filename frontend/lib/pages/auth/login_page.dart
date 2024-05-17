import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/pages/auth/widgets/auth_form.dart';
import 'package:erp_frontend_v2/widgets/buttons/submit_button.dart';
import 'package:erp_frontend_v2/widgets/custom_checkbox.dart';
import 'package:erp_frontend_v2/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
              color: CustomColor.slate_50,
              border: Border.all(color: Colors.red)),
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/logo.png',
                              width: 40,
                              color: CustomColor.textPrimary,
                            ),
                            Text(
                              'iBill',
                              style: CustomStyle.titleText,
                            ),
                          ],
                        ),
                        Text(
                          'start_to_grow_your_business'.tr(context),
                          style: CustomStyle.regular24(),
                        ),
                      ],
                    ),
                  ),
                  const Gap(40),
                  Expanded(
                    child: _styledContainer(
                      child: Image.asset(
                        'images/dashboard_image.png',
                        width: MediaQuery.of(context).size.width * 0.64,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(0),
              _styledContainer(
                  padding: const EdgeInsets.all(40),
                  width: MediaQuery.of(context).size.width * 0.23,
                  color: CustomColor.bgSecondary,
                  borderRadius: BorderRadius.circular(28),
                  child: const AuthForm()),
            ],
          )),
    );
  }

  Widget _styledContainer({
    required Widget child,
    double? width,
    double? height,
    Color? color,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
  }) {
    return Container(
        padding: padding,
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 20,
              blurRadius: 40,
              offset: const Offset(0, 35), // changes position of shadow
            ),
          ],
          borderRadius: borderRadius,
        ),
        child: child);
  }
}
