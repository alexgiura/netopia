import 'dart:math';

import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CustomLineChart extends StatefulWidget {
  /// * Array with data for first `FlSpot`
  /// * Simple example: `[6, 9, 5, 3, 5, 1, 6, 8]`
  /// * If we want to start with third month we should add `null` values for first two months like this:
  /// * Second example: `[null, null, 6, 9, 5, 3, 5, 1, 6, 8]`
  final List<double?> firstData;

  /// * Array with data for second `FlSpot`
  /// * Simple example: `[6, 9, 5, 3, 5, 1, 6, 8]`
  /// * If we want to start with third month *we should add `null` values for first two months*
  /// * Second example: `[null, null, 6, 9, 5, 3, 5, 1, 6, 8]`
  final List<double?> secondData;

  /// Color for first data line
  /// * Default value is: `CustomColor.chartColor1`
  final Color? firstColor;

  /// Color for second data line:
  /// * Default value is: `CustomColor.chartColor2`
  final Color? secondColor;

  /// * TextStyle for bottom titles
  /// * Default value is: `CustomStyle.semibold10(color: CustomColor.slate_700)`
  final TextStyle? bottomTextStyle;

  const CustomLineChart({
    super.key,
    required this.firstData,
    required this.secondData,
    this.firstColor = CustomColor.chartColor1,
    this.secondColor = CustomColor.chartColor2,
    this.bottomTextStyle,
  });

  @override
  State<CustomLineChart> createState() => _CustomLineChartState();
}

class _CustomLineChartState extends State<CustomLineChart> {
  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            right: 12,
            left: 12,
            top: 12,
            bottom: 0,
          ),
          child: LineChart(
            mainData(),
          ),
        ),
      ],
    );
  }

  double calculateReservedSize(String text) {
    // calculate the size of the text
    return text.length * 10.0;
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    var style = widget.bottomTextStyle ??
        CustomStyle.semibold10(color: CustomColor.slate_700);
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = Text('ian'.tr(context), style: style);
        break;
      case 2:
        text = Text('feb'.tr(context), style: style);
        break;
      case 3:
        text = Text('mar'.tr(context), style: style);
        break;
      case 4:
        text = Text('apr'.tr(context), style: style);
        break;
      case 5:
        text = Text('may'.tr(context), style: style);
        break;
      case 6:
        text = Text('jun'.tr(context), style: style);
        break;
      case 7:
        text = Text('jul'.tr(context), style: style);
        break;
      case 8:
        text = Text('aug'.tr(context), style: style);
        break;
      case 9:
        text = Text('sep'.tr(context), style: style);
        break;
      case 10:
        text = Text('oct'.tr(context), style: style);
        break;
      case 11:
        text = Text('nov'.tr(context), style: style);
        break;
      case 12:
        text = Text('dec'.tr(context), style: style);
        break;
      default:
        text = Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    var style = CustomStyle.semibold10(color: CustomColor.slate_700);

    String text = value.toStringAsFixed(0);
    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    List<double?> combinedData = [
      ...widget.firstData,
      ...widget.secondData,
    ];
    combinedData.sort((a, b) {
      if (a == null && b == null) return 0;
      if (a == null) return -1;
      if (b == null) return 1;
      return a.compareTo(b);
    });
    return LineChartData(
      gridData: FlGridData(
        drawHorizontalLine: true,
        show: true,
        drawVerticalLine: true,
        horizontalInterval: getInterval(),
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: CustomColor.slate_300,
            strokeWidth: 0.5,
            dashArray: [5, 2],
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: CustomColor.slate_300,
            strokeWidth: 0.5,
            dashArray: [5, 2],
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 45,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: getInterval(),
            getTitlesWidget: leftTitleWidgets,
            reservedSize: calculateReservedSize(combinedData.last.toString()),
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(
          color: CustomColor.slate_300,
          width: 1,
        ),
      ),
      minX: 0,
      maxX: widget.firstData.length - 1 > widget.secondData.length - 1
          ? widget.firstData.length - 1
          : widget.secondData.length - 1,
      minY: combinedData.first,
      // merge firstData and secondData and get the max value
      maxY: combinedData.last,
      lineBarsData: [
        LineChartBarData(
          spots: List.generate(
            widget.firstData.length,
            (index) => FlSpot(index.toDouble(), widget.firstData[index] ?? 0),
          ),
          isCurved: true,
          color: CustomColor.chartColor1,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            color: CustomColor.chartColor1.withOpacity(0.2),
          ),
        ),
        LineChartBarData(
          spots: List.generate(
            widget.secondData.length,
            (index) => FlSpot(index.toDouble(), widget.secondData[index] ?? 0),
          ),
          isCurved: true,
          color: CustomColor.chartColor2,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            color: CustomColor.chartColor2.withOpacity(0.2),
          ),
        ),
      ],
    );
  }

  double getInterval() {
    double max = 0;
    for (int i = 0; i < widget.firstData.length; i++) {
      if (widget.firstData[i] != null && widget.firstData[i]! > max) {
        max = widget.firstData[i]!;
      }
    }
    for (int i = 0; i < widget.secondData.length; i++) {
      if (widget.secondData[i] != null && widget.secondData[i]! > max) {
        max = widget.secondData[i]!;
      }
    }
    return max / 10;
  }
}
