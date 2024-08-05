import 'package:erp_frontend_v2/models/report/spline_chart_model.dart';
import 'package:erp_frontend_v2/pages/dashboard/widgets/circle_chart.dart';
import 'package:erp_frontend_v2/pages/dashboard/widgets/large_screen.dart';
import 'package:erp_frontend_v2/pages/dashboard/widgets/line_chart.dart';
import 'package:erp_frontend_v2/pages/dashboard/widgets/medium_screen.dart';
import 'package:erp_frontend_v2/pages/dashboard/widgets/small_screen.dart';
import 'package:erp_frontend_v2/services/report.dart';
import 'package:erp_frontend_v2/utils/extensions.dart';
import 'package:erp_frontend_v2/utils/responsiveness.dart';
import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/pages/dashboard/widgets/item_stock_chart.dart';
import 'package:erp_frontend_v2/pages/report/widgets/spline_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:erp_frontend_v2/constants/style.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  late List<SplineChartData> _chartData = [];

  @override
  void initState() {
    super.initState();
    _fetchSplineChart();
  }

  Future<void> _fetchSplineChart() async {
    try {
      final chartService = ReportService();
      final chartData = await chartService.getRevenueChart();

      setState(() {
        _chartData = chartData;
      });
    } catch (error) {
      //
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: ResponsiveWidget.isSmallScreen(context) ? 0 : 24,
        right: ResponsiveWidget.isSmallScreen(context) ? 0 : 24,
        top: ResponsiveWidget.isSmallScreen(context) ? 56 : 15,
        bottom: ResponsiveWidget.isSmallScreen(context) ? 0 : 24,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'dashboard'.tr(context),
                  style: CustomStyle.titleText,
                ),
                Spacer(),
              ],
            ),
            Expanded(child: _body(context)),
          ],
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return ResponsiveWidget(
      largeScreen: LargeScreen(
        chartData: _chartData,
      ),
      mediumScreen: MediumScreen(
        chartData: _chartData,
      ),
      smallScreen: SmallScreen(
        chartData: _chartData,
      ),
    );
  }
}
