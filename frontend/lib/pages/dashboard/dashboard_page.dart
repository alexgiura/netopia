import 'package:erp_frontend_v2/utils/responsiveness.dart';
import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/pages/dashboard/widgets/item_stock_chart.dart';
import 'package:erp_frontend_v2/pages/report/widgets/spline_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/style.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: ResponsiveWidget.isSmallScreen(context) ? 0 : 24,
        right: ResponsiveWidget.isSmallScreen(context) ? 0 : 24,
        top: ResponsiveWidget.isSmallScreen(context) ? 56 : 32,
        bottom: ResponsiveWidget.isSmallScreen(context) ? 0 : 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'dashboard'.tr(context),
                  style: CustomStyle.titleText,
                ),
                Spacer()
              ],
            ),
            SizedBox(height: 16),
            SizedBox(height: 250, child: Text('data')),
            SizedBox(height: 16),
            SizedBox(height: 300, child: ItemStockChart()),
          ],
        ),
      ),
    );
  }
}

// class _DashboardPageState extends ConsumerState<DashboardPage> {
//   Map<String, String> _localizedStrings = {};

//   @override
//   void initState() {
//     loadLocalizedStrings();
//     super.initState();
//   }

//   Future<void> loadLocalizedStrings() async {
//     String jsonString = await rootBundle.loadString("assets/lang/ro.json");
//     Map<String, dynamic> jsonMap = json.decode(jsonString);
//     _localizedStrings = jsonMap.map((key, value) {
//       return MapEntry(key, value.toString());
//     });
//   }

//   @override
//   Widget build(BuildContext context) {}
// }
