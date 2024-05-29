import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/helpers/responsiveness.dart';
import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/pages/auth/register/widgets/register_form.dart';
import 'package:erp_frontend_v2/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.bgSecondary,
      body: Container(
        decoration: context.deviceWidth > 817
            ? BoxDecoration(
                color: CustomColor.slate_50,
                borderRadius: BorderRadius.circular(40),
              )
            : null,
        margin: EdgeInsets.all(context.width03),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 30,
                    color: CustomColor.textPrimary,
                  ),
                  const Text(
                    'iBill',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: CustomColor.textPrimary,
                    ),
                  ),
                ],
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
            flex: context.deviceWidth < 1100 ? 3 : 4,
            // flex: 4,
            child: _styledContainer(
                margin: EdgeInsets.only(
                    // top: context.height05,
                    // bottom: context.height15,
                    // left: context.width02,
                    // right: context.width10),
                    ),
                padding: const EdgeInsets.all(30),
                color: CustomColor.bgSecondary,
                borderRadius: BorderRadius.circular(28),
                child: RegisterForm(
                  key: GlobalKey(),
                )),
          )
        ],
      ),
    );
  }

  Widget _largeScreen() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: _flexResponsive(context),
          // flex: 7,
          child: Container(
            margin: EdgeInsets.only(
                top: context.height10,
                bottom: context.height10,
                left: context.width10,
                right: context.width02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
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
                  child: AspectRatio(
                    aspectRatio: 1.9,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: Image.asset(
                        'images/dashboard_image.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        // Gap(context.width05),
        Flexible(
          flex: context.deviceWidth < 1100 ? 3 : 4,
          // flex: 4,
          child: _styledContainer(
              margin: EdgeInsets.only(
                  top: context.height05,
                  bottom: context.height15,
                  left: context.width02,
                  right: context.width10),
              padding: const EdgeInsets.all(30),
              color: CustomColor.bgSecondary,
              borderRadius: BorderRadius.circular(28),
              child: RegisterForm(
                key: GlobalKey(),
              )),
        )
      ],
    );
  }

  Widget _styledContainer({
    required Widget child,
    double? width,
    double? height,
    Color? color,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    BorderRadius? borderRadius,
    Border? border,
  }) {
    return Container(
        padding: padding,
        margin: margin,
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          border: border,
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
      return 3;
    } else {
      return 7;
    }
  }
}
