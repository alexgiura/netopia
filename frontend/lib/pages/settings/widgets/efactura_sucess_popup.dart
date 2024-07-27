import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/routing/routes.dart';
import 'package:erp_frontend_v2/widgets/dialog_widgets/warning_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EfacturaSuccessPopup extends StatefulWidget {
  const EfacturaSuccessPopup({super.key});

  @override
  State<EfacturaSuccessPopup> createState() => _EfacturaSuccessPopupState();
}

class _EfacturaSuccessPopupState extends State<EfacturaSuccessPopup> {
  @override
  Widget build(BuildContext context) {
    return WarningCustomDialog(
      type: WarningType.success,
      title: 'success_authorization'.tr(context),
      subtitle: 'success_authorization_description'.tr(context),
      primaryButtonText: 'close'.tr(context),
      primaryButtonAction: () {
        Navigator.of(context).pop();
      },
    );
  }
}
