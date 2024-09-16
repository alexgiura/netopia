import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/routing/routes.dart';
import 'package:erp_frontend_v2/widgets/top_nav/account_button.dart';
import 'package:erp_frontend_v2/widgets/custom_text_field_1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../constants/style.dart';
import '../../utils/responsiveness.dart';
import '../custom_menu_search_bar.dart';

class TopNav extends ConsumerWidget implements PreferredSizeWidget {
  const TopNav({super.key, required this.scaffoldKey});
  final GlobalKey<ScaffoldState> scaffoldKey;
  @override
  Size get preferredSize => const Size.fromHeight(76);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      toolbarHeight: 76,
      titleSpacing: 0.0,
      leading: ResponsiveWidget.isSmallScreen(context)
          ? IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                scaffoldKey.currentState?.openDrawer();
              })
          : null,
      automaticallyImplyLeading: false,
      title: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: ResponsiveWidget.isSmallScreen(context) ? 16 : 24,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (ResponsiveWidget.isSmallScreen(context))
              Expanded(child: Container()),
            !ResponsiveWidget.isSmallScreen(context)
                ? Expanded(
                    child: CustomMenuSearchBar(
                      hintText: 'search_page'.tr(context),
                      onValueChanged: (p0) {},
                    ),
                  )
                : Container(),
            if (!ResponsiveWidget.isSmallScreen(context))
              Expanded(child: Container()),
            const Gap(8),
            Stack(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: const ShapeDecoration(
                    shape: CircleBorder(),
                    color: CustomColor.accentNeutral,
                  ),
                  child: IconButton(
                      splashRadius: 20,
                      icon: const Icon(Icons.settings_outlined),
                      onPressed: () {}),
                ),
              ],
            ),
            const Gap(8),
            Stack(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const ShapeDecoration(
                    shape: CircleBorder(),
                    color: CustomColor.accentNeutral,
                  ),
                  child: IconButton(
                      splashRadius: 20,
                      icon: const Icon(Icons.notifications_none),
                      onPressed: () {}),
                ),
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
            CustomAccountButton(),
          ],
        ),
      ),
      iconTheme: const IconThemeData(color: CustomColor.textPrimary),
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
  }
}
