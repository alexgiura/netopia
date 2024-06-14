import 'package:erp_frontend_v2/constants/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData customTheme(BuildContext context) {
  return ThemeData(
    useMaterial3: false,
    textTheme:
        GoogleFonts.wixMadeforDisplayTextTheme(Theme.of(context).textTheme),
    // canvasColor: CustomColor.white,
    pageTransitionsTheme: PageTransitionsTheme(builders: {
      TargetPlatform.iOS: const FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.android: const FadeUpwardsPageTransitionsBuilder(),
      // Default transition for other platforms like web
      TargetPlatform.linux: CustomScaleTransitionBuilder(),
      TargetPlatform.macOS: CustomScaleTransitionBuilder(),
      TargetPlatform.windows: CustomScaleTransitionBuilder(),
    }),
    iconTheme: const IconThemeData(color: CustomColor.textPrimary),
    //dividerColor: Colors.transparent, // Set the divider color to transparent

    hoverColor: Colors.transparent,
    focusColor: Colors.transparent,
    dialogBackgroundColor: CustomColor.white,
    checkboxTheme: CheckboxThemeData(
      side: MaterialStateBorderSide.resolveWith(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return const BorderSide(color: CustomColor.textPrimary, width: 1.5);
          }
          return const BorderSide(color: CustomColor.slate_400);
        },
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      fillColor: const MaterialStatePropertyAll(Colors.transparent),
      checkColor: const MaterialStatePropertyAll(
        CustomColor.textPrimary,
      ),
      overlayColor: const MaterialStatePropertyAll(Colors.transparent),
    ),
  );
}

// This type is working with  pageTransitionsTheme
class CustomFadeTransitionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return customFadeTransition(context, animation, secondaryAnimation, child);
  }
}

class CustomScaleTransitionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return customScaleTransition(context, animation, secondaryAnimation, child);
  }
}

class CustomSlideTransitionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return customSlideTransition(context, animation, secondaryAnimation, child);
  }
}

// tis type is used in routes
Widget customFadeTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return FadeTransition(
    opacity: animation,
    child: child,
  );
}

Widget customScaleTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return ScaleTransition(
    scale: animation.drive(
      Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeInOut)),
    ),
    child: child,
  );
}

Widget customSlideTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return SlideTransition(
    position: animation.drive(
      Tween(
        begin: const Offset(1.0, 0.0), // Right to left
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeInOut)),
    ),
    child: child,
  );
}
