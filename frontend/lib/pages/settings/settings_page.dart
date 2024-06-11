import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/helpers/responsiveness.dart';
import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/pages/efactura/efactura_error_popup.dart';
import 'package:erp_frontend_v2/pages/efactura/efactura_info_popup.dart';
import 'package:erp_frontend_v2/pages/settings/widgets/settings_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:gap/gap.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final GlobalKey<SettingsCardState> cardKey = GlobalKey<SettingsCardState>();
  final GlobalKey<SettingsCardState> cardKey2 = GlobalKey<SettingsCardState>();
  double maxHeight = 0.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomColor.lightest,
      padding: EdgeInsets.only(
        left: ResponsiveWidget.isSmallScreen(context) ? 16 : 24,
        right: ResponsiveWidget.isSmallScreen(context) ? 16 : 24,
        top: ResponsiveWidget.isSmallScreen(context) ? 32 : 56,
        bottom: ResponsiveWidget.isSmallScreen(context) ? 0 : 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  'settings'.tr(context),
                  style: CustomStyle.titleText,
                ),
                Spacer()
              ],
            ),
            Gap(16.0),
            ResponsiveWidget(
              largeScreen: SingleChildScrollView(
                child: _largeScreen(context),
              ),
              mediumScreen: SingleChildScrollView(
                child: _mediumScreen(context),
              ),
              smallScreen: SingleChildScrollView(
                child: _smallScreen(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _largeScreen(BuildContext context) {
    final List<Widget> infoCards = _buildSettingsCards();
    final int numberOfRows = (infoCards.length / 4).ceil();

    return LayoutGrid(
      columnSizes: [1.fr, 1.fr, 1.fr, 1.fr],
      rowSizes: List.generate(numberOfRows, (_) => auto),
      rowGap: 16.0,
      columnGap: 16.0,
      children: infoCards,
    );
  }

  Widget _mediumScreen(BuildContext context) {
    final List<Widget> infoCards = _buildSettingsCards();
    final int numberOfRows = (infoCards.length / 2).ceil();

    return LayoutGrid(
      columnSizes: [1.fr, 1.fr],
      rowSizes: List.generate(numberOfRows, (_) => auto),
      rowGap: 16.0,
      columnGap: 16.0,
      children: infoCards,
    );
  }

  Widget _smallScreen(BuildContext context) {
    final List<Widget> infoCards = _buildSettingsCards();

    return LayoutGrid(
      columnSizes: [1.fr],
      rowSizes: List.generate(infoCards.length, (_) => auto),
      rowGap: 16.0,
      columnGap: 16.0,
      children: infoCards,
    );
  }

  List<Widget> _buildSettingsCards() {
    List<Widget> list = [
      Row(
        children: [
          Expanded(
            child: SettingsCard(
              iconData: Icons.receipt_long_outlined,
              title: 'e_factura'.tr(context),
              subtitle: 'e_factura_description'.tr(context),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const EfacturaInfoPopup();
                  },
                );
              },
            ),
          ),
        ],
      ),
    ];

    return list;
  }
}
