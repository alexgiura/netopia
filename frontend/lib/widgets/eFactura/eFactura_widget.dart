import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/models/document/document_model.dart';
import 'package:erp_frontend_v2/providers/document/document_provider.dart';
import 'package:erp_frontend_v2/services/eFactura.dart';
import 'package:erp_frontend_v2/widgets/buttons/primary_button.dart';
import 'package:erp_frontend_v2/widgets/custom_status_chip.dart';
import 'package:erp_frontend_v2/widgets/dialog_widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

Widget eFacturaWidget(Document document, BuildContext context, WidgetRef ref) {
  if (document.isDeleted == true) {
    return Container();
  } else if (document.eFactura!.status!.isEmpty) {
    return Container();
  } else if (document.eFactura!.status != null &&
      document.eFactura!.status == 'success') {
    return Row(
      children: [
        CustomStatusChip(type: StatusType.success, label: 'sent'.tr(context)),
      ],
    );
  } else if (document.eFactura!.status == 'error' ||
      document.eFactura!.status == null) {
    return Row(
      children: [
        CustomStatusChip(
            type: StatusType.error, label: 'error_general'.tr(context)),
        const Gap(4),
        SvgPicture.asset(
          'assets/icons/error_outline.svg',
          height: 20,
          width: 20,
        )
      ],
    );
  } else if (document.eFactura!.status == 'new' ||
      document.eFactura!.status == 'processing') {
    return Row(
      children: [
        CustomStatusChip(
            type: StatusType.warning, label: 'processing'.tr(context)),
      ],
    );
  }
  return Container();
}

Widget eFacturaStatus(Document document, BuildContext context) {
  if (document.eFactura!.status == null || document.eFactura!.status == '') {
    return Text(
      '-',
      style: CustomStyle.semibold14(),
    );
  } else {
    if (document.eFactura!.status == 'success') {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle_outline,
              color: CustomColor.greenText, size: 20),
          const Gap(6),
          Text('processed'.tr(context),
              style: CustomStyle.semibold14(color: CustomColor.greenText)),
        ],
      );
    } else if (document.eFactura!.status == 'error') {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline_rounded,
              color: CustomColor.error, size: 20),
          const Gap(6),
          Text('unprocessed'.tr(context),
              style: CustomStyle.semibold14(color: CustomColor.error)),
        ],
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.access_time_outlined,
              color: CustomColor.warning, size: 20),
          const Gap(6),
          Text('processing'.tr(context),
              style: CustomStyle.semibold14(color: CustomColor.warning)),
        ],
      );
    }
  }
}
