import 'package:erp_frontend_v2/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  const GradientBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: CustomColor.bgPrimaryLinear,
      ),
      child: child,
    );
  }
}

Widget buildTextWithLink({
  required String text,
  required String linkText,
  required Uri url,
  required TextStyle textStyle,
  required TextStyle linkStyle,
}) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        text,
        style: textStyle,
      ),
      InkWell(
        child: Text(
          linkText,
          style: linkStyle,
        ),
        onTap: () {
          launchUrl(url);
        },
      )
    ],
  );
}
