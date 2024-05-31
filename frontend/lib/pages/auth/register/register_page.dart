import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/helpers/responsiveness.dart';
import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/pages/auth/register/widgets/register_form.dart';
import 'package:erp_frontend_v2/utils/extensions.dart';
import 'package:erp_frontend_v2/widgets/custom_container.dart';
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
        decoration: context.deviceWidth > mediumScreenSize
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
                    'OptiManage',
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
            flex: context.deviceWidth < customScreenSize ? 3 : 4,
            // flex: 4,
            child: CustomContainer(
                margin: EdgeInsets.only(
                    // top: context.height05,
                    // bottom: context.height15,
                    // left: context.width02,
                    // right: context.width10),
                    ),
                padding: const EdgeInsets.all(30),
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
                          Image.asset(
                            'assets/images/logo.png',
                            width: 30,
                            color: CustomColor.textPrimary,
                          ),
                          Text(
                            'app_name'.tr(context),
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
                CustomContainer(
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
          flex: context.deviceWidth < customScreenSize ? 3 : 4,
          child: CustomContainer(
              margin: EdgeInsets.only(
                  top: context.height05,
                  bottom: context.height15,
                  left: context.width02,
                  right: context.width10),
              padding: const EdgeInsets.all(30),
              child: RegisterForm(
                key: GlobalKey(),
              )),
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
