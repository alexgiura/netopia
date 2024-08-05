import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/models/report/spline_chart_model.dart';
import 'package:erp_frontend_v2/pages/dashboard/widgets/bar_chart.dart';
import 'package:erp_frontend_v2/pages/dashboard/widgets/circle_chart.dart';
import 'package:erp_frontend_v2/pages/dashboard/widgets/item_stock_chart.dart';
import 'package:erp_frontend_v2/pages/dashboard/widgets/line_chart.dart';
import 'package:erp_frontend_v2/services/report.dart';
import 'package:erp_frontend_v2/utils/extensions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hive/hive.dart';

class LargeScreen extends StatefulWidget {
  final List<SplineChartData> chartData;

  const LargeScreen({
    required this.chartData,
    Key? key,
  }) : super(key: key);

  @override
  State<LargeScreen> createState() => _LargeScreenState();
}

class _LargeScreenState extends State<LargeScreen> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              padding: const EdgeInsets.only(top: 32),
              width: double.infinity,
              child: _firstRow(context)),
          const Gap(10),
          Expanded(
              child: Container(
                  width: double.infinity, child: _secondRow(context))),
          const Gap(10),
          Expanded(
              child: Container(
                  width: double.infinity,
                  height: 310,
                  child: _thirdRow(context))),
        ],
      ),
    );
  }

  Widget _firstRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: _contentSection(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FittedBox(
                  child: RichText(
                      text: TextSpan(
                          text: '23.000,00',
                          style: CustomStyle.regular40(),
                          children: [
                        TextSpan(
                            text: 'ron'.tr(context),
                            style: CustomStyle.regular24()),
                      ])),
                ),
                Text(
                  'total_income'.tr(context),
                  style: CustomStyle.semibold14(color: CustomColor.greenGray),
                ),
              ],
            ),
          ),
        ),
        const Gap(8),
        Expanded(
          flex: 3,
          child: _contentSection(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RichText(
                    text: TextSpan(
                        text: '1.100,00',
                        style: CustomStyle.regular24(),
                        children: [
                      TextSpan(
                          text: 'ron'.tr(context),
                          style: CustomStyle.regular16()),
                    ])),
                const Gap(8),
                Text(
                  'last_7_days'.tr(context),
                  style: CustomStyle.semibold14(color: CustomColor.greenGray),
                ),
              ],
            ),
          ),
        ),
        const Gap(8),
        Expanded(
          flex: 3,
          child: _contentSection(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RichText(
                    text: TextSpan(
                        text: '11.300,00',
                        style: CustomStyle.regular24(),
                        children: [
                      TextSpan(
                          text: 'ron'.tr(context),
                          style: CustomStyle.regular16()),
                    ])),
                const Gap(8),
                Text(
                  'last_12_days'.tr(context),
                  style: CustomStyle.semibold14(color: CustomColor.greenGray),
                ),
              ],
            ),
          ),
        ),
        const Gap(8),
        Expanded(
          flex: 3,
          child: _contentSection(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RichText(
                    text: TextSpan(
                        text: '3.230,00',
                        style: CustomStyle.regular24(),
                        children: [
                      TextSpan(
                          text: 'ron'.tr(context),
                          style: CustomStyle.regular16()),
                    ])),
                const Gap(8),
                Text(
                  'last_30_days'.tr(context),
                  style: CustomStyle.semibold14(color: CustomColor.greenGray),
                ),
              ],
            ),
          ),
        ),
        const Gap(10),
        SizedBox(
          width: context.width14,
          child: Row(
            children: [
              Expanded(
                child: _contentSection(
                  height: 126,
                  backgroundColor: CustomColor.bgDark,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()..scale(-1.0, 1.0),
                        child: const Icon(Icons.assignment_return_outlined,
                            color: CustomColor.accentColor),
                      ),
                      const Gap(8),
                      Text(
                        'add_in_incomes'.tr(context),
                        textAlign: TextAlign.center,
                        style: CustomStyle.semibold13(
                            color: CustomColor.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(8),
              Expanded(
                child: _contentSection(
                  height: 126,
                  backgroundColor: CustomColor.bgDark,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.assignment_return_outlined,
                        color: CustomColor.accentColor,
                      ),
                      const Gap(8),
                      Text(
                        'add_in_exits'.tr(context),
                        textAlign: TextAlign.center,
                        style: CustomStyle.semibold13(
                            color: CustomColor.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const Gap(8),
        SizedBox(
          width: context.width14,
          child: Row(
            children: [
              Expanded(
                child: _contentSection(
                  height: 126,
                  backgroundColor: CustomColor.bgDark,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.warehouse_outlined,
                        color: CustomColor.accentColor,
                      ),
                      const Gap(8),
                      Text(
                        'add_in_warehouse'.tr(context),
                        textAlign: TextAlign.center,
                        style: CustomStyle.semibold13(
                            color: CustomColor.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(8),
              Expanded(
                child: _contentSection(
                  height: 126,
                  backgroundColor: CustomColor.bgDark,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.precision_manufacturing_outlined,
                        color: CustomColor.accentColor,
                      ),
                      const Gap(8),
                      Text(
                        'add_in_production'.tr(context),
                        textAlign: TextAlign.center,
                        style: CustomStyle.semibold13(
                            color: CustomColor.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _secondRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 1,
            child: _contentSection(
                height: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('sales_evolution'.tr(context),
                          style: CustomStyle.medium20(
                              color: CustomColor.greenGray)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              backgroundColor: CustomColor.chartColor1,
                              radius: 7,
                            ),
                            const Gap(4),
                            Text(DateTime.now().year.toString(),
                                style: CustomStyle.semibold14()),
                          ],
                        ),
                        const Gap(24),
                        Row(
                          children: [
                            const CircleAvatar(
                              backgroundColor: CustomColor.chartColor2,
                              radius: 7,
                            ),
                            const Gap(4),
                            Text("${DateTime.now().year - 1}",
                                style: CustomStyle.semibold14()),
                          ],
                        ),
                      ],
                    ),
                    widget.chartData.isNotEmpty
                        ? Flexible(
                            child: CustomLineChart(
                            firstData:
                                widget.chartData.map((e) => e.y!).toList(),
                            secondData: widget.chartData
                                .map((e) => e.secondY!)
                                .toList(),
                          ))
                        : const Center(child: CircularProgressIndicator())
                  ],
                ))),
        const Gap(10),
        _contentSection(
          height: double.infinity,
          width: context.width14,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'sales_by_category'.tr(context),
                style: CustomStyle.medium20(color: CustomColor.greenGray),
              ),
              RichText(
                  text: TextSpan(
                      text: '5.932,99',
                      style: CustomStyle.regular24(),
                      children: [
                    TextSpan(
                        text: 'ron'.tr(context),
                        style: CustomStyle.regular16()),
                  ])),
              const Gap(16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: CustomColor.chartColor1,
                          radius: 7,
                        ),
                        const Gap(4),
                        Text(
                          "Categoria x",
                          style: CustomStyle.semibold12(),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: CustomColor.chartColor2,
                          radius: 7,
                        ),
                        const Gap(4),
                        Text(
                          "Categoria y",
                          style: CustomStyle.semibold12(),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const Gap(12),
              Expanded(
                  child: CircleChart(
                sections: [
                  PieChartSectionData(
                    color: CustomColor.chartColor1.withOpacity(0.2),
                    title: "20%",
                    value: 20,
                  ),
                  PieChartSectionData(
                    color: CustomColor.chartColor2.withOpacity(0.2),
                    title: "80%",
                    value: 80,
                  ),
                ],
              )),
            ],
          ),
        ),
        const Gap(8),
        _contentSection(
          height: double.infinity,
          width: context.width14,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'sales_by_partners'.tr(context),
                style: CustomStyle.medium20(color: CustomColor.greenGray),
              ),
              RichText(
                  text: TextSpan(
                      text: '5.932,99',
                      style: CustomStyle.regular24(),
                      children: [
                    TextSpan(
                        text: 'ron'.tr(context),
                        style: CustomStyle.regular16()),
                  ])),
              const Gap(16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: CustomColor.chartColor1,
                          radius: 7,
                        ),
                        const Gap(4),
                        Text(
                          "Per. fizice",
                          style: CustomStyle.semibold12(),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: CustomColor.chartColor2,
                          radius: 7,
                        ),
                        const Gap(4),
                        Text(
                          "Pers. juridice",
                          style: CustomStyle.semibold12(),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const Gap(12),
              Expanded(
                  child: CircleChart(
                sections: [
                  PieChartSectionData(
                    color: CustomColor.chartColor1.withOpacity(0.2),
                    title: "35%",
                    value: 35,
                  ),
                  PieChartSectionData(
                    color: CustomColor.chartColor2.withOpacity(0.2),
                    title: "65%",
                    value: 65,
                  ),
                ],
              )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _thirdRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 8,
          child: _contentSection(
            height: double.infinity,
            child: Column(
              children: [
                Text(
                  'last_entries'.tr(context),
                  style: CustomStyle.medium20(color: CustomColor.greenGray),
                ),
                Flexible(child: const ItemStockChart()),
              ],
            ),
          ),
        ),
        const Gap(10),
        _contentSection(
          height: double.infinity,
          width: context.width28_30,
          child: BarChartCustom(
            title: 'entries_and_exits_for_first_quarter'.tr(context),
            incomeData: [3200, 7400, 5500],
            expensesData: [2000, 5000, 4000],
          ),
        ),
      ],
    );
  }

  Widget _contentSection({
    required Widget child,
    double? height,
    double? width,
    Color? backgroundColor,
  }) {
    return Container(
        height: height ?? 126,
        width: width,
        padding: const EdgeInsets.all(24),
        decoration: CustomStyle.customContainerDecoration(
            backgroundColor: backgroundColor,
            border: true,
            borderRadius: CustomStyle.customBorderRadiusMid),
        child: child);
  }
}
