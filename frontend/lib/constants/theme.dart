import 'package:erp_frontend_v2/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData customTheme(BuildContext context) {
  return ThemeData(
    useMaterial3: false,
    textTheme: GoogleFonts.robotoFlexTextTheme(Theme.of(context).textTheme),
    // canvasColor: CustomColor.white,
    pageTransitionsTheme: PageTransitionsTheme(builders: {
      TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
      // Default transition for other platforms like web
      TargetPlatform.linux: CustomScaleTransitionBuilder(),
      TargetPlatform.macOS: CustomScaleTransitionBuilder(),
      TargetPlatform.windows: CustomScaleTransitionBuilder(),
    }),
    iconTheme: const IconThemeData(color: CustomColor.darkest),
    //dividerColor: Colors.transparent, // Set the divider color to transparent
    hoverColor: CustomColor.lightest,
    dialogBackgroundColor: CustomColor.white,

    // splashColor: Colors.white,
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
