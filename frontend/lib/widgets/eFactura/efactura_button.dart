import 'package:erp_frontend_v2/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

class eFacturaButton extends StatefulWidget {
  final Future<void> Function()? asyncOnTap;

  const eFacturaButton({
    super.key,
    this.asyncOnTap,
  });

  @override
  _eFacturaButtonState createState() => _eFacturaButtonState();
}

class _eFacturaButtonState extends State<eFacturaButton> {
  bool _isLoading = false;

  void _handleTap() async {
    if (widget.asyncOnTap != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        await widget.asyncOnTap!.call();
      } finally {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _isLoading ? null : _handleTap,
      child: Row(
        children: [
          _isLoading
              ? const Center(
                  child: SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          CustomColor.textSecondary),
                    ),
                  ),
                )
              : SvgPicture.asset(
                  'assets/icons/efactura.svg',
                  height: 18,
                  width: 18,
                ),
          Gap(8),
          Text(
            'Trimite e-Factura',
            style: CustomStyle.semibold14(color: CustomColor.textSecondary),
          )
        ],
      ),
    );
  }
}
