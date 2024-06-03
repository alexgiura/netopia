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

  // New colors&gradients from figma design
  static const LinearGradient bgPrimary = LinearGradient(colors: [
    Color(0xffEFF5E9),
    Color(0xffF2F8F7),
  ]);
  static const bgSecondary = Color(0xffFDFFFF);
  static const accentColor = Color(0xffCEFF7B);
  static const textPrimary = Color(0xff010101);
  static const textSecondary = Color(0xffF1F5EA);
  static const slate_50 = Color(0xffF8FAFC);
  static const slate_100 = Color(0xffF1F5F9);
  static const slate_200 = Color(0xffE2E8F0);
  static const slate_300 = Color(0xffCBD5E1);
  static const slate_400 = Color(0xff94A3B8);
  static const slate_500 = Color(0xff64748B);
  static const slate_600 = Color(0xff475569);
  static const slate_700 = Color(0xff334155);
  static const slate_800 = Color(0xff1E293B);
  static const slate_900 = Color(0xff0F172A);
  static const redErrorRequired = Color(0xffF43F5E);
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

  static TextStyle errorText =
      CustomStyle.labelSemibold12(color: CustomColor.redErrorRequired);

  static const TextStyle primaryButtonText = TextStyle(
    fontSize: 16,
    color: CustomColor.white,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle secondaryButtonText = TextStyle( 
    fontSize: 16,
    color: CustomColor.textPrimary,
    fontWeight: FontWeight.normal,
  );

  static TextStyle tertiaryButtonText = CustomStyle.buttonSemibold14();
  static TextStyle tertiaryButtonTextUnderline =
      CustomStyle.buttonSemibold14(isUnderline: true);

  //-----------------New text styles from figma design--------------------------//
  static TextStyle regular64({Color color = CustomColor.textPrimary}) {
    return TextStyle(
      fontSize: 64,
      color: color,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle bold64({Color color = CustomColor.textPrimary}) {
    return TextStyle(
      fontSize: 64,
      color: color,
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle regular48({Color color = CustomColor.textPrimary}) {
    return TextStyle(
      fontSize: 48,
      color: color,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle bold48({Color color = CustomColor.textPrimary}) {
    return TextStyle(
      fontSize: 48,
      color: color,
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle regular32({Color color = CustomColor.textPrimary}) {
    return TextStyle(
      fontSize: 32,
      color: color,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle bold32({Color color = CustomColor.textPrimary}) {
    return TextStyle(
      fontSize: 32,
      color: color,
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle regular24({Color color = CustomColor.textPrimary}) {
    return TextStyle(
      fontSize: 24,
      color: color,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle bold24({Color color = CustomColor.textPrimary}) {
    return TextStyle(
      fontSize: 24,
      color: color,
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle medium20({Color color = CustomColor.textPrimary}) {
    return TextStyle(
      fontSize: 20,
      color: color,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle bold20({Color color = CustomColor.textPrimary}) {
    return TextStyle(
      fontSize: 20,
      color: color,
      fontWeight: FontWeight.w700,
    );
  }

  //paragraph

  static TextStyle regular16({Color color = CustomColor.textPrimary}) {
    return TextStyle(
      fontSize: 16,
      color: color,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle bold16({Color color = CustomColor.textPrimary}) {
    return TextStyle(
      fontSize: 16,
      color: color,
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle regular14({Color color = CustomColor.textPrimary}) {
    return TextStyle(
      fontSize: 14,
      color: color,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle bold14({Color color = CustomColor.textPrimary}) {
    return TextStyle(
      fontSize: 14,
      color: color,
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle regular12({Color color = CustomColor.textPrimary}) {
    return TextStyle(
      fontSize: 12,
      color: color,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle bold12({Color color = CustomColor.textPrimary}) {
    return TextStyle(
      fontSize: 12,
      color: color,
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle regular10({Color color = CustomColor.textPrimary}) {
    return TextStyle(
      fontSize: 10,
      color: color,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle bold10({Color color = CustomColor.textPrimary}) {
    return TextStyle(
      fontSize: 10,
      color: color,
      fontWeight: FontWeight.w700,
    );
  }

  //button text styles

  static TextStyle buttonMedium14({Color color = CustomColor.textPrimary}) {
    return TextStyle(
      fontSize: 14,
      color: color,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle buttonSemibold14(
      {Color color = CustomColor.textPrimary, bool? isUnderline}) {
    return TextStyle(
      fontSize: 14,
      color: color,
      decoration: isUnderline == true ? TextDecoration.underline : null,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle buttonMedium12({Color color = CustomColor.textPrimary}) {
    return TextStyle(
      fontSize: 12,
      color: color,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle buttonSemibold12({Color color = CustomColor.textPrimary}) {
    return TextStyle(
      fontSize: 12,
      color: color,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle buttonMedium10({Color color = CustomColor.textPrimary}) {
    return TextStyle(
      fontSize: 10,
      color: color,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle buttonSemibold10({Color color = CustomColor.textPrimary}) {
    return TextStyle(
      fontSize: 10,
      color: color,
      fontWeight: FontWeight.w600,
    );
  }

  //label

  static TextStyle labelSemibold16(
      {Color color = CustomColor.textPrimary, bool? isUnderline}) {
    return TextStyle(
      fontSize: 16,
      color: color,
      decoration: isUnderline == true ? TextDecoration.underline : null,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle labelSemibold14(
      {Color color = CustomColor.textPrimary, bool? isUnderline}) {
    return TextStyle(
      fontSize: 14,
      color: color,
      decoration: isUnderline == true ? TextDecoration.underline : null,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle labelSemibold12({Color color = CustomColor.textPrimary}) {
    return TextStyle(
      fontSize: 12,
      color: color,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle labelSemibold10({Color color = CustomColor.textPrimary}) {
    return TextStyle(
      fontSize: 10,
      color: color,
      fontWeight: FontWeight.w600,
    );
  }

  // -----------------End of new text styles from figma design-----------------//

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
  static ButtonStyle tertiaryUnderlineButton = ButtonStyle(
    overlayColor: MaterialStatePropertyAll(Colors.transparent),
    textStyle:
        MaterialStatePropertyAll(CustomStyle.tertiaryButtonTextUnderline),
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

  static ButtonStyle submitBlackButton = ButtonStyle(
    padding: MaterialStateProperty.all(
        EdgeInsets.symmetric(horizontal: 14, vertical: 20)),
    backgroundColor: MaterialStateProperty.all(CustomColor.textPrimary),
    shape: MaterialStateProperty.all(RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    )),
    textStyle: MaterialStateProperty.all(
      CustomStyle.buttonSemibold14(
        color: CustomColor.textPrimary,
      ),
    ),
    iconSize: MaterialStateProperty.all(18),
    iconColor: MaterialStateProperty.all(CustomColor.white),
  );

  static ButtonStyle secondaryElevatedButtonStyle = ButtonStyle(
    padding: MaterialStateProperty.all(
        const EdgeInsets.symmetric(horizontal: 14, vertical: 20)),
    textStyle: MaterialStateProperty.all(
      buttonSemibold14(color: CustomColor.textPrimary),
    ),
    backgroundColor: MaterialStateProperty.all(CustomColor.white),
    shape: MaterialStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    ),
    side: MaterialStateProperty.all(
      const BorderSide(color: CustomColor.textPrimary),
    ),
  );

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

  static BoxDecoration customStyledContainerDecorationShadow = BoxDecoration(
    color: CustomColor.bgSecondary,
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        spreadRadius: 20,
        blurRadius: 40,
        offset: const Offset(0, 35), // changes position of shadow
      )
    ],
    borderRadius: BorderRadius.circular(28),
  );

// Border Radius
  static BorderRadius customBorderRadius = BorderRadius.circular(6);
}
