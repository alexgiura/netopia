import 'package:erp_frontend_v2/helpers/responsiveness.dart';
import 'package:erp_frontend_v2/widgets/large_screen.dart';
import 'package:erp_frontend_v2/widgets/side_menu.dart';
import 'package:erp_frontend_v2/widgets/top_nav.dart';
import 'package:flutter/material.dart';

class AppLayout extends StatelessWidget {
  const AppLayout({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

    return Row(
      children: [
        if (!ResponsiveWidget.isSmallScreen(context)) const SideMenu(),
        Expanded(
          child: Scaffold(
            key: scaffoldKey,
            appBar: topNavigationBar(context, scaffoldKey),
            drawer: const SideMenu(),
            body: ResponsiveWidget(
                largeScreen: LargeScreen(child: child),
                smallScreen: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: child,
                )),
          ),
        )
      ],
    );
  }
}
