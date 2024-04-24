import 'package:erp_frontend_v2/constants/sizes.dart';
import 'package:flutter/material.dart';

// Colors
class CustomColor {
  static const Color white = Color(0xFFFFFFFF);
  // static const Color lightest = Color(0xFFF7F8FA);
  static const Color lightest = Color(0xFFF7F8FC);
  static const Color light = Color(0xFFCACED4);
  //static const Color medium = Color(0xFF868CA7);
  static const Color medium = Color(0xFFA4A6B3);
  static const Color dark = Color(0xFF505673);
  static const Color darkest = Color(0xFF191C32);
  static const Color active = Color(0xFF4958EC);
}
//from other project
// const light = Color(0xFFF7F8FC);
// const lightGrey = Color(0xFFA4A6B3);
// const dark = Color(0xFF363740);
// const active = Color(0xFF3C19C0);

class CustomStyle {
  // Text styles
  static const TextStyle menuText =
      TextStyle(fontSize: 18, fontWeight: FontWeight.normal);
  static const TextStyle selectedMenuText = TextStyle(
      fontSize: 18, fontWeight: FontWeight.normal, color: CustomColor.active);

  static const TextStyle submenuText = TextStyle(
      fontSize: 18, color: CustomColor.dark, fontWeight: FontWeight.normal);

  static const TextStyle titleText = TextStyle(
      fontSize: 24, color: CustomColor.darkest, fontWeight: FontWeight.bold);

  static const TextStyle subtitleText = TextStyle(
      fontSize: 18, color: CustomColor.darkest, fontWeight: FontWeight.w600);

  static const TextStyle bodyText = TextStyle(
      fontSize: 15, color: CustomColor.darkest, fontWeight: FontWeight.normal);
  static const TextStyle bodyTextMedium = TextStyle(
      fontSize: 15, color: CustomColor.darkest, fontWeight: FontWeight.w500);

  static const TextStyle bodyTextBold = TextStyle(
      fontSize: 15, color: CustomColor.darkest, fontWeight: FontWeight.w600);

  static const TextStyle tableHeaderText = TextStyle(
      fontSize: 15, color: CustomColor.darkest, fontWeight: FontWeight.w600);

  static const TextStyle smallText = TextStyle(
      fontSize: 16, color: CustomColor.dark, fontWeight: FontWeight.normal);

  static const TextStyle labelText = TextStyle(
      fontSize: 15, color: CustomColor.dark, fontWeight: FontWeight.normal);

  static const TextStyle tagText = TextStyle(
      fontSize: 15, color: CustomColor.white, fontWeight: FontWeight.w500);

  static const TextStyle hintText = TextStyle(
    fontSize: 16,
    color: CustomColor.medium,
    fontWeight: FontWeight.normal,
    fontStyle: FontStyle.italic,
  );

  static const TextStyle errorText =
      TextStyle(fontSize: 14, color: Colors.red, fontWeight: FontWeight.normal);

  static const TextStyle primaryButtonText = TextStyle(
    fontSize: 16,
    color: CustomColor.white,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle secondaryButtonText = TextStyle(
    fontSize: 16,
    color: CustomColor.medium,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle tertiaryButtonText = TextStyle(
    fontSize: 16,
    color: CustomColor.active,
    fontWeight: FontWeight.normal,
    // decoration: TextDecoration.underline,
  );
  // Button Style
  static ButtonStyle activeButton = ButtonStyle(
    padding: const MaterialStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 14)), // Adjust horizontal padding
    fixedSize: const MaterialStatePropertyAll(
        Size.fromHeight(CustomSize.buttonHeight)),
    backgroundColor: const MaterialStatePropertyAll(CustomColor.active),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: CustomStyle.customBorderRadius,
      ),
    ),
    textStyle: MaterialStateProperty.resolveWith<TextStyle?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return CustomStyle.primaryButtonText.copyWith(
            color: CustomColor.light,
          );
        }
        // Default style
        return CustomStyle.primaryButtonText;
      },
    ),

    iconSize: MaterialStateProperty.resolveWith<double?>(
      (Set<MaterialState> states) {
        return 18.0;
      },
    ),
    iconColor: MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return CustomColor.light; // Color for disabled state
        }
        // Default color
        return CustomColor.white; // Replace with your default color
      },
    ),
  );

  static ButtonStyle secondaryButton = ButtonStyle(
      padding: const MaterialStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 14)), // Adjust horizontal padding
      fixedSize: const MaterialStatePropertyAll(
          Size.fromHeight(CustomSize.buttonHeight)),
      backgroundColor: const MaterialStatePropertyAll(CustomColor.white),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: CustomStyle.customBorderRadius,
        ),
      ),
      side: MaterialStateProperty.resolveWith<BorderSide?>(
        (Set<MaterialState> states) {
          return const BorderSide(color: CustomColor.medium, width: 1.0);
        },
      ),
      textStyle:
          const MaterialStatePropertyAll(CustomStyle.secondaryButtonText),
      iconSize: const MaterialStatePropertyAll(18),
      iconColor: const MaterialStatePropertyAll(CustomColor.medium));

  static ButtonStyle tertiaryButton = ButtonStyle(
    overlayColor: MaterialStatePropertyAll(Colors.transparent),
    textStyle: MaterialStatePropertyAll(CustomStyle.tertiaryButtonText),
    iconSize: MaterialStatePropertyAll(18),
    iconColor: MaterialStatePropertyAll(CustomColor.active),
    padding: MaterialStateProperty.all(EdgeInsets.zero),
  );

  // Button Style
  static ButtonStyle negativeButton = ButtonStyle(
      backgroundColor: const MaterialStatePropertyAll(Colors.red),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
        borderRadius: CustomStyle.customBorderRadius,
      )));

  // Container decoration
  static BoxDecoration customContainerDecoration = BoxDecoration(
    color: CustomColor.white,
    borderRadius: CustomStyle.customBorderRadius,
    border: Border.all(color: CustomColor.light, width: 0.5),
    boxShadow: [
      BoxShadow(
          offset: const Offset(0, 6),
          color: CustomColor.medium.withOpacity(.1),
          blurRadius: 12)
    ],
  );

  // Container decoration
  static BoxDecoration customErrorContainerDecoration = BoxDecoration(
    color: CustomColor.white,
    borderRadius: CustomStyle.customBorderRadius,
    border: Border.all(color: Colors.red, width: 1.0),
    boxShadow: [
      BoxShadow(
          offset: const Offset(0, 6),
          color: CustomColor.medium.withOpacity(.1),
          blurRadius: 12)
    ],
  );

  // Container decoration
  static BoxDecoration customInactiveContainerDecoration = BoxDecoration(
    color: CustomColor.lightest,
    borderRadius: CustomStyle.customBorderRadius,
    border: Border.all(
      color: CustomColor.light, // Use Colors.light color for the border
      width: 0.5, // Border width
    ),
  );

  // Container decoration
  static BoxDecoration customContainerDecorationNoShadow = BoxDecoration(
    color: CustomColor.white,
    borderRadius: CustomStyle.customBorderRadius,
    border: Border.all(
      color: CustomColor.light, // Use Colors.light color for the border
      width: 0.5, // Border width
    ),
  );

// Border Radius
  static BorderRadius customBorderRadius = BorderRadius.circular(6);
}
