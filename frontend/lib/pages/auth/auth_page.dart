import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/utils/responsiveness.dart';
import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/pages/auth/widgets/login_form.dart';
import 'package:erp_frontend_v2/pages/auth/widgets/register_form.dart';
import 'package:erp_frontend_v2/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  bool _login = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.bgSecondary,
      body: Container(
        decoration: context.deviceWidth > mediumScreenSize
            ? BoxDecoration(
                color: CustomColor.slate_50,
                borderRadius: BorderRadius.circular(40),
              )
            : null,
        margin: EdgeInsets.all(context.width02),
        child: ResponsiveWidget(
          largeScreen: _largeScreen(),
          smallScreen: _smallScreen(),
        ),
      ),
    );
  }

  Widget _smallScreen() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: context.width05,
                color: CustomColor.textPrimary,
              ),
              Gap(context.height02),
              FittedBox(
                child: Text(
                  'start_to_grow_your_business'.tr(context),
                  style: CustomStyle.regular24(),
                ),
              ),
              Gap(context.height05),
            ],
          ),
          // register form
          Flexible(
            flex: context.deviceWidth < customScreenSize ? 3 : 4,
            child: Container(
                decoration: CustomStyle.customContainerDecoration(
                    borderRadius: BorderRadius.circular(32), boxShadow: true),
                padding: const EdgeInsets.all(30),
                child: _login
                    ? LoginForm(
                        key: GlobalKey(),
                        changeForm: () => setState(() {
                          _login = !_login;
                        }),
                      )
                    : RegisterForm(
                        key: GlobalKey(),
                        changeForm: () => setState(() {
                          _login = !_login;
                        }),
                      )),
          )
        ],
      ),
    );
  }

  Widget _largeScreen() {
    return Container(
      padding: EdgeInsets.all(context.width03),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 6,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: _leftPart(),
            ),
          ),
          Gap(context.width03),
          Flexible(
            flex: context.deviceWidth < customScreenSize ? 4 : 3,
            child: Container(
                decoration: CustomStyle.customContainerDecoration(
                    borderRadius: BorderRadius.circular(32), boxShadow: true),
                child: _rightPart()),
          )
        ],
      ),
    );
  }

  Widget _rightPart() {
    return Container(
        decoration: CustomStyle.customContainerDecoration(
            borderRadius: BorderRadius.circular(32), boxShadow: true),
        padding: const EdgeInsets.all(30),
        child: _login
            ? LoginForm(
                key: GlobalKey(),
                changeForm: () => setState(() {
                  _login = !_login;
                }),
              )
            : RegisterForm(
                key: GlobalKey(),
                changeForm: () => setState(() {
                  _login = !_login;
                }),
              ));
  }

  Widget _leftPart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: context.width05,
                color: CustomColor.textPrimary,
              ),
              Text(
                'start_to_grow_your_business'.tr(context),
                style: CustomStyle.regular24(),
              ),
            ],
          ),
        ),
        Gap(context.height05),
        Container(
          decoration: CustomStyle.customContainerDecoration(
              borderRadius: BorderRadius.circular(32), boxShadow: true),
          width: double.infinity,
          padding: const EdgeInsets.all(0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Image.asset(
              'assets/images/preview-dashboard.png',
              fit: BoxFit.fill,
            ),
          ),
        )
      ],
    );
  }

  int _flexResponsive(BuildContext context) {
    if (context.deviceWidth < mediumScreenSize) {
      return 1;
    } else if (context.deviceWidth < largeScreenSize) {
      return 3;
    } else {
      return 7;
    }
  }
}
