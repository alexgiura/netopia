import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/providers/user_provider.dart';
import 'package:erp_frontend_v2/utils/responsiveness.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

// Creăm un StateProvider pentru a gestiona starea vizibilității dropdown-ului
final dropdownVisibilityProvider = StateProvider<bool>((ref) => false);

class CustomAccountButton extends ConsumerWidget {
  const CustomAccountButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);
    final isDropdownVisible = ref.watch(dropdownVisibilityProvider);

    // Folosim un GlobalKey pentru a obține poziția widget-ului de referință
    final GlobalKey _buttonKey = GlobalKey();
    OverlayEntry? dropdown; // Variabilă pentru a stoca OverlayEntry
    void hideDropdown() {
      if (dropdown != null) {
        dropdown!.remove();
        dropdown = null;
        ref.read(dropdownVisibilityProvider.notifier).state = false;
      }
    }

    void showDropdown() {
      final overlay = Overlay.of(context);
      final renderBox =
          _buttonKey.currentContext!.findRenderObject() as RenderBox;
      final position = renderBox.localToGlobal(Offset.zero);

      dropdown = OverlayEntry(
        builder: (context) {
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              // Închidem dropdown-ul dacă utilizatorul apasă în afara acestuia
              hideDropdown();
            },
            child: Stack(
              children: [
                Positioned(
                  top: position.dy + renderBox.size.height + 15,
                  left: position.dx,
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: renderBox.size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          itemTile(
                              title: 'my_profile'.tr(context),
                              icon: Icons.person_pin_outlined,
                              onTap: () {
                                hideDropdown();
                              }),
                          const Divider(
                            color: CustomColor.slate_200,
                            height: 1,
                          ),
                          itemTile(
                              title: 'logout'.tr(context),
                              icon: Icons.logout,
                              onTap: () async {
                                await _logout();
                                hideDropdown();
                              }),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );

      overlay.insert(dropdown!);
    }

    return InkWell(
      key: _buttonKey,
      onTap: () {
        if (isDropdownVisible) {
          hideDropdown(); // Închide dropdown-ul dacă este deja deschis
        } else {
          ref.read(dropdownVisibilityProvider.notifier).state = true;
          showDropdown(); // Arată dropdown-ul dacă nu este deschis
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: const ShapeDecoration(
              shape: CircleBorder(),
              color: CustomColor.accentNeutral,
            ),
            child: const Center(
              child: Icon(
                Icons.person_outline,
                size: 24,
              ),
            ),
          ),
          userState.when(
            skipLoadingOnReload: true,
            skipLoadingOnRefresh: true,
            data: (user) {
              return !ResponsiveWidget.isSmallScreen(context)
                  ? Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        user.company!.name,
                        style: CustomStyle.medium16(),
                      ),
                    )
                  : Container();
            },
            loading: () {
              return const CircularProgressIndicator.adaptive();
            },
            error: (error, stackTrace) {
              return Container();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  Widget itemTile(
      {required String title,
      required IconData icon,
      required Function onTap}) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: CustomColor.slate_500,
            ),
            const Gap(8),
            Text(
              title,
              style: CustomStyle.regular14(),
            ),
          ],
        ),
      ),
    );
  }
}
