import 'package:erp_frontend_v2/pages/efactura/widgets/efactura_error_popup.dart';
import 'package:erp_frontend_v2/pages/efactura/widgets/efactura_info_popup.dart';
import 'package:erp_frontend_v2/pages/efactura/widgets/efactura_sucess_popup.dart';
import 'package:erp_frontend_v2/routing/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EfacturaPage extends StatefulWidget {
  const EfacturaPage({super.key, this.state, this.error});
  final String? state;
  final String? error;

  @override
  State<EfacturaPage> createState() => _EfacturaPageState();
}

class _EfacturaPageState extends State<EfacturaPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showDialog();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return (widget.error != null && widget.error != '')
            ? EfacturaErrorPopup()
            : (widget.state != null)
                ? EfacturaSuccessPopup()
                : EfacturaInfoPopup();
      },
    ).then((_) {
      context.goNamed(
        settingsPageName,
      );
    });
  }
}
