import 'package:erp_frontend_v2/constants/style.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CircleChart extends StatelessWidget {
  /// This is a array with PieChartSectionData example:
  ///  PieChartSectionData( color: CustomColor.chartColor1.withOpacity(0.2), title: "20%", value: 20, )
  final List<PieChartSectionData> sections;
  const CircleChart({super.key, required this.sections});

  @override
  Widget build(BuildContext context) {
    return PieChart(PieChartData(
      borderData: FlBorderData(
          // show: true,
          border: Border.all(width: 5, color: CustomColor.bgDark)),
      sections: sections,
    ));
  }
}
