import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/providers/user_provider.dart';
import 'package:erp_frontend_v2/utils/responsiveness.dart';
import 'package:erp_frontend_v2/utils/util_widgets.dart';
import 'package:erp_frontend_v2/widgets/side_menu/side_menu.dart';
import 'package:erp_frontend_v2/widgets/top_nav/top_nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toastification/toastification.dart';

class AppLayout extends ConsumerStatefulWidget {
  const AppLayout({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  ConsumerState<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends ConsumerState<AppLayout> {
  @override
  void initState() {
    super.initState();
    ref
        .read(userProvider.notifier)
        .getUserById(FirebaseAuth.instance.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

    return GradientBackground(
      child: Row(
        children: [
          if (!ResponsiveWidget.isSmallScreen(context)) const SideMenu(),
          Expanded(
            child: Scaffold(
              key: scaffoldKey,
              appBar: TopNav(scaffoldKey: scaffoldKey),
              drawer: const SideMenu(),
              body: LayoutBuilder(
                builder: (context, constraints) {
                  return ToastificationWrapper(
                    child: ResponsiveWidget(
                      largeScreen: Padding(
                        padding: const EdgeInsets.only(
                            left: 16, top: 24, right: 24, bottom: 24),
                        child: widget.child,
                      ),
                      smallScreen: Padding(
                        padding: const EdgeInsets.all(16),
                        child: widget.child,
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
