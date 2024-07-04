import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/models/document/document_model.dart';
import 'package:erp_frontend_v2/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

Widget? eFacturaWidget(Document document, BuildContext context) {
  if (document.isDeleted == true) {
    return null;
  } else if (document.efacturaStatus!.isEmpty) {
    return PrimaryButton(
        text: 'send'.tr(context),
        style: CustomStyle.primaryBlackButton,
        onPressed: () => _sendEfactura(context, document));
  } else if (document.efacturaStatus != null &&
      document.efacturaStatus == 'success') {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.check_circle_outline,
            color: CustomColor.greenText, size: 20),
        const Gap(10),
        Text('processed'.tr(context),
            style: CustomStyle.semibold14(color: CustomColor.greenText)),
      ],
    );
  } else if (document.efacturaStatus == 'error') {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PrimaryButton(
          style: CustomStyle.primaryBlackButton,
          text: 'resend'.tr(context),
          asyncOnPressed: () async {
            return _sendEfactura(context, document);
          },
        ),
        const Gap(10),
        SvgPicture.asset(
          'assets/icons/error_outline.svg',
          height: 20,
          width: 20,
        )
      ],
    );
  }
}

void _sendEfactura(BuildContext context, Document document) {
  // Send eFactura
  // activate the loading indicator
  // Call the API to send the eFactura
  // If the API call is successful, update the document with the new eFactura status
}
