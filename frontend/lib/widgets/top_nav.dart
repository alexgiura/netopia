import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/routing/routes.dart';
import 'package:erp_frontend_v2/widgets/buttons/nav_button.dart';
import 'package:erp_frontend_v2/widgets/custom_search_bar.dart';
import 'package:erp_frontend_v2/widgets/custom_text_field_1.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../constants/style.dart';
import '../utils/responsiveness.dart';

AppBar topNavigationBar(BuildContext context, GlobalKey<ScaffoldState> key) =>
    AppBar(
      toolbarHeight: 76,
      titleSpacing: 0.0,
      leading: ResponsiveWidget.isSmallScreen(context)
          ? IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                key.currentState?.openDrawer();
              })
          : null,
      automaticallyImplyLeading: false,
      title: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveWidget.isSmallScreen(context) ? 16 : 24,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            !ResponsiveWidget.isSmallScreen(context)
                ? Expanded(
                    child: CustomSearchBar(
                      hintText: 'search_page'.tr(context),
                      onValueChanged: (p0) {},
                    ),
                  )
                : const SizedBox.shrink(),
            Expanded(child: Container()),
            IconButton(
                splashRadius: 20,
                icon: const Icon(Icons.settings_outlined),
                onPressed: () {
                  context.go(settingsPageRoute);
                }),
            // const Gap(8),
            Stack(
              children: [
                IconButton(
                    splashRadius: 20,
                    icon: const Icon(Icons.notifications_none),
                    onPressed: () {}),
                Positioned(
                  top: 7,
                  right: 7,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                        color: CustomColor.green,
                        borderRadius: BorderRadius.circular(30),
                        border:
                            Border.all(color: CustomColor.lightest, width: 2)),
                  ),
                )
              ],
            ),
            const Gap(16),
            Container(
              width: 1,
              height: 30,
              color: CustomColor.slate_300,
            ),
            const Gap(16),
            CustomNavButton(
              onTap: () {},
              icon: Icons.person_outline,
              text: 'Alex Giura',
            ),
          ],
        ),
      ),
      iconTheme: const IconThemeData(color: CustomColor.textPrimary),
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
