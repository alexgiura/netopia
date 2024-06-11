import 'package:erp_frontend_v2/routing/routes.dart';
import 'package:erp_frontend_v2/widgets/custom_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/style.dart';
import '../helpers/responsiveness.dart';

AppBar topNavigationBar(BuildContext context, GlobalKey<ScaffoldState> key) =>
    AppBar(
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
          children: [
            !ResponsiveWidget.isSmallScreen(context)
                ? Expanded(
                    child: CustomSearchBar(
                      hintText: "Cauta",
                      onValueChanged: (p0) {
                        //
                      },
                    ),
                  )
                : SizedBox.shrink(),
            Expanded(child: Container()),
            IconButton(
                splashRadius: 22,
                icon: const Icon(Icons.settings_outlined),
                onPressed: () {
                  context.go(settingsPageRoute);
                }),
            Stack(
              children: [
                IconButton(
                    splashRadius: 22,
                    icon: const Icon(Icons.notifications_none),
                    onPressed: () {}),
                Positioned(
                  top: 7,
                  right: 7,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                        color: CustomColor.active,
                        borderRadius: BorderRadius.circular(30),
                        border:
                            Border.all(color: CustomColor.lightest, width: 2)),
                  ),
                )
              ],
            ),
            const SizedBox(width: 16),
            Container(
              width: 1,
              height: 22,
              color: CustomColor.light,
            ),
            const SizedBox(width: 14),
            const CircleAvatar(
              radius: 22,
              backgroundColor: CustomColor.lightest,
              child: Icon(Icons.person_outline, color: CustomColor.dark),
            ),
            const SizedBox(
              width: 8,
            ),
            const Text(
              'Alex Giura',
              style: CustomStyle.bodyText,
            ),
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(0.5),
        child: Container(
          color: CustomColor.light, // Set your custom border color here
          height: 0.5,
        ),
      ),
      iconTheme: const IconThemeData(color: CustomColor.dark),
      elevation: 0,
      backgroundColor: CustomColor.white,
    );

// Widget customBar(BuildContext context, GlobalKey<ScaffoldState> key) =>
//     Container(
//       padding: EdgeInsets.symmetric(horizontal: 16),
//       color: CustomColor.white,
//       height: 100, // Standard app bar height
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           // Leading Widget
//           if (!ResponsiveWidget.isSmallScreen(context))
//             Text('ERP', style: CustomStyle.subtitleText)
//           else
//             IconButton(
//                 icon: const Icon(Icons.menu),
//                 onPressed: () {
//                   key.currentState?.openDrawer();
//                 }),

//           // Title and Actions
//           Row(
//             children: [
//               // ... rest of your title and actions
//               IconButton(
//                   splashRadius: 22,
//                   icon: const Icon(Icons.settings_outlined),
//                   onPressed: () {}),
//               // Notifications Icon
//               // ... your notification icon and badge
//               // Profile Icon
//               // ... your profile icon and name
//             ],
//           ),
//         ],
//       ),
//     );
