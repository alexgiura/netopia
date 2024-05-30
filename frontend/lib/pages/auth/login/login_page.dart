import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/helpers/responsiveness.dart';
import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/pages/auth/login/widgets/auth_form.dart';
import 'package:erp_frontend_v2/utils/extensions.dart';
import 'package:erp_frontend_v2/widgets/large_screen.dart';
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
      body: Padding(
        padding: EdgeInsets.only(
            left: context.width05,
            right: context.width05,
            top: context.height10,
            bottom: context.height15),
        child: ResponsiveWidget(
          largeScreen: LargeScreen(child: _largeScreen()),
          smallScreen: SingleChildScrollView(child: _smallScreen()),
        ),
      ),
    );
  }

  Widget _largeScreen() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: _flexResponsive(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: context.deviceWidth < 1400
                ? MainAxisAlignment.start
                : MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (context.deviceWidth < 768)
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
              Gap(context.height05),
              _styledContainer(
                child: Image.asset(
                  'assets/images/dashboard_image.png',
                  fit: BoxFit.fitWidth,
                ),
              ),
            ],
          ),
        ),
        Gap(context.width05),
        Expanded(
          flex: context.deviceWidth < 1100 ? 4 : 3,
          child: _styledContainer(
              padding: const EdgeInsets.all(40),
              color: CustomColor.bgSecondary,
              borderRadius: BorderRadius.circular(28),
              child: const AuthForm()),
        ),
      ],
    );
  }

  Widget _smallScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: context.width05,
                  color: CustomColor.textPrimary,
                ),
                Text(
                  'iBill',
                  style: CustomStyle.titleText,
                ),
              ],
            ),
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                'start_to_grow_your_business'.tr(context),
                style: CustomStyle.regular24(),
              ),
            ),
          ],
        ),
        Gap(context.height05),
        _styledContainer(
            padding: const EdgeInsets.all(40),
            color: CustomColor.bgSecondary,
            borderRadius: BorderRadius.circular(28),
            child: const AuthForm()),
      ],
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

  int _flexResponsive(BuildContext context) {
    if (context.deviceWidth < 768) {
      return 1;
    } else if (context.deviceWidth < 1150) {
      return 4;
    } else {
      return 7;
    }
  }
}
