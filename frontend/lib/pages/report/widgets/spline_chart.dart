import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/models/report/spline_chart_model.dart';
import 'package:erp_frontend_v2/services/report.dart';
import 'package:erp_frontend_v2/pages/report/widgets/revenue_info.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:math';

class SplineChart extends StatefulWidget {
  const SplineChart({super.key});

  @override
  State<SplineChart> createState() => _SplineChartState();
}

class _SplineChartState extends State<SplineChart> {
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
      decoration: CustomStyle.customContainerDecoration,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: SfCartesianChart(
              plotAreaBorderWidth: 0,
              title: ChartTitle(
                  text:
                      'Sales ${DateTime.now().year} vs ${DateTime.now().year - 1}'),
              legend: const Legend(
                  isVisible: true,
                  position: LegendPosition.right,
                  alignment: ChartAlignment.center),
              primaryXAxis: CategoryAxis(
                  majorGridLines: const MajorGridLines(width: 0),
                  labelPlacement: LabelPlacement.onTicks),
              primaryYAxis: NumericAxis(
                  minimum: 0.00,
                  maximum:
                      approximateToNearestUnit(maxFromChartData(_chartData)),
                  axisLine: const AxisLine(width: 0),
                  edgeLabelPlacement: EdgeLabelPlacement.shift,
                  labelFormat: '{value} RON  ',
                  majorTickLines: const MajorTickLines(size: 0)),
              series: _getDefaultSplineSeries(),
              tooltipBehavior: TooltipBehavior(enable: true),
            ),
          ),
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    RevenueInfo(
                      title: "Toda's revenue",
                      amount: "230",
                    ),
                    RevenueInfo(
                      title: "Last 7 days",
                      amount: "1,100",
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    RevenueInfo(
                      title: "Last 30 days",
                      amount: "3,230",
                    ),
                    RevenueInfo(
                      title: "Last 12 months",
                      amount: "11,300",
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Returns the list of chart series which need to render on the spline chart.
  List<SplineSeries<SplineChartData, String>> _getDefaultSplineSeries() {
    int currentYear = DateTime.now().year;
    return <SplineSeries<SplineChartData, String>>[
      SplineSeries<SplineChartData, String>(
        dataSource: _chartData,
        xValueMapper: (SplineChartData sales, _) => sales.x as String,
        yValueMapper: (SplineChartData sales, _) => sales.y,
        markerSettings: const MarkerSettings(isVisible: true),
        name: currentYear.toString(),
      ),
      SplineSeries<SplineChartData, String>(
        dataSource: _chartData,
        name: (currentYear - 1).toString(),
        markerSettings: const MarkerSettings(isVisible: true),
        xValueMapper: (SplineChartData sales, _) => sales.x as String,
        yValueMapper: (SplineChartData sales, _) => sales.secondY,
      )
    ];
  }

  @override
  void dispose() {
    _chartData.clear();
    super.dispose();
  }

  double maxFromChartData(List<SplineChartData> chartData) {
    return chartData.fold<double>(0, (previousMax, data) {
      double currentMax = max(data.y ?? 0.0, data.secondY ?? 0.0);
      return max(previousMax, currentMax);
    });
  }

  double approximateToNearestUnit(double number) {
    number *= 1.4;
    if (number == 0.0) return 0.0;

    // Determine the order of magnitude
    int magnitude = (log(number.abs()) / log(10)).floor();

    // Calculate the rounding factor based on the magnitude
    double roundingFactor = pow(10, magnitude).toDouble();

    // Round the number to the nearest unit of its magnitude
    double roundedNumber = (number / roundingFactor).round() * roundingFactor;

    return roundedNumber;
  }
}
