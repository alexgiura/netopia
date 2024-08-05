import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class BarChartCustom extends StatefulWidget {
  /// The title of the bar chart
  final String title;

  /// Array with data for income
  final List<double?> incomeData;

  /// Array with data for expenses
  final List<double?> expensesData;

  /// Color for first data line
  /// * Default value is: `CustomColor.chartColor1`
  final Color? firstColor;

  /// Color for second data line:
  /// * Default value is: `CustomColor.chartColor2`
  final Color? secondColor;

  const BarChartCustom({
    Key? key,
    required this.title,
    required this.incomeData,
    required this.expensesData,
    this.firstColor = CustomColor.chartColor1,
    this.secondColor = CustomColor.chartColor2,
  }) : super(key: key);

  @override
  State<BarChartCustom> createState() => _BarChartCustomState();
}

class _BarChartCustomState extends State<BarChartCustom> {
  @override
  Widget build(BuildContext context) {
    List<double?> combinedData = [
      ...widget.incomeData,
      ...widget.expensesData,
    ];
    combinedData.sort((a, b) {
      if (a == null && b == null) return 0;
      if (a == null) return -1;
      if (b == null) return 1;
      return a.compareTo(b);
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: CustomStyle.medium20(color: CustomColor.greenGray),
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                gridData: FlGridData(
                  drawHorizontalLine: true,
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: getInterval(),
                  //
                  verticalInterval: 0.3,
                  getDrawingHorizontalLine: (value) {
                    return const FlLine(
                      color: CustomColor.slate_800,
                      strokeWidth: 0.1,
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
                maxY: combinedData.last,
                barTouchData: BarTouchData(enabled: true),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(),
                  topTitles: AxisTitles(
                    axisNameSize: 32,
                    axisNameWidget: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              backgroundColor: CustomColor.chartColor1,
                              radius: 5,
                            ),
                            Gap(4),
                            Text('Intrări', style: CustomStyle.semibold14()),
                          ],
                        ),
                        Gap(24),
                        Row(
                          children: [
                            const CircleAvatar(
                              backgroundColor: CustomColor.chartColor2,
                              radius: 5,
                            ),
                            const Gap(4),
                            Text('Ieșiri', style: CustomStyle.semibold14()),
                          ],
                        ),
                      ],
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 20,
                      // interval: 0,
                      getTitlesWidget: bottomTitlesWidgets,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: 2000,
                      getTitlesWidget: leftTitleWidgets,
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: CustomColor.slate_300, width: 1),
                ),
                barGroups: List.generate(
                  widget.incomeData.length,
                  (index) {
                    return BarChartGroupData(
                      barsSpace: 12,
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: widget.incomeData[index] as double,
                          borderSide: BorderSide(
                            color: widget.firstColor!,
                            width: 2,
                          ),
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(6),
                              topRight: Radius.circular(6)),
                          color: widget.firstColor!.withOpacity(0.2),
                          width: 20,
                        ),
                        BarChartRodData(
                          toY: widget.expensesData[index] as double,
                          borderSide: BorderSide(
                            color: widget.secondColor!,
                            width: 2,
                          ),
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(6),
                              topRight: Radius.circular(6)),
                          color: widget.secondColor!.withOpacity(0.2),
                          width: 20,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget bottomTitlesWidgets(double value, TitleMeta meta) {
    var style = CustomStyle.semibold10(color: CustomColor.slate_700);
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = Text('ian'.tr(context), style: style);
        break;
      case 1:
        text = Text('feb'.tr(context), style: style);
        break;
      case 2:
        text = Text('mar'.tr(context), style: style);
        break;
      case 3:
        text = Text('apr'.tr(context), style: style);
        break;
      case 4:
        text = Text('may'.tr(context), style: style);
        break;
      case 5:
        text = Text('jun'.tr(context), style: style);
        break;
      case 6:
        text = Text('jul'.tr(context), style: style);
        break;
      case 7:
        text = Text('aug'.tr(context), style: style);
        break;
      case 8:
        text = Text('sep'.tr(context), style: style);
        break;
      case 9:
        text = Text('oct'.tr(context), style: style);
        break;
      case 10:
        text = Text('nov'.tr(context), style: style);
        break;
      case 11:
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

  double getInterval() {
    double max = 0;
    for (int i = 0; i < widget.incomeData.length; i++) {
      if (widget.incomeData[i] != null && widget.incomeData[i]! > max) {
        max = widget.incomeData[i]!;
      }
    }
    for (int i = 0; i < widget.expensesData.length; i++) {
      if (widget.expensesData[i] != null && widget.expensesData[i]! > max) {
        max = widget.expensesData[i]!;
      }
    }
    return max / 10;
  }

  double? lerpDouble(num? a, num? b, double t) {
    if (a == b || (a?.isNaN ?? false) && (b?.isNaN ?? false)) {
      return a?.toDouble();
    }
    a ??= 0.0;
    b ??= 0.0;
    assert(
        a.isFinite, 'Cannot interpolate between finite and non-finite values');
    assert(
        b.isFinite, 'Cannot interpolate between finite and non-finite values');
    assert(t.isFinite, 't must be finite when interpolating between values');
    return a * (1.0 - t) + b * t;
  }
}
