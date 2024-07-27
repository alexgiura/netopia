import 'package:erp_frontend_v2/pages/settings/widgets/efactura_error_popup.dart';
import 'package:erp_frontend_v2/services/eFactura.dart';
import 'package:erp_frontend_v2/utils/util_functions.dart';
import 'package:flutter/material.dart';

Future<void> eFacturaAutorize(BuildContext context) async {
  try {
    //
    final url = await EfacturaService().generateEfacturaAuthorizationLink();
    launch(url, isNewTab: false);
  } catch (e) {
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const EfacturaErrorPopup();
      },
    );
  }
}
