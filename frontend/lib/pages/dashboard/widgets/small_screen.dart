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

class SmallScreen extends StatefulWidget {
  final List<SplineChartData> chartData;

  const SmallScreen({
    required this.chartData,
    Key? key,
  }) : super(key: key);

  @override
  State<SmallScreen> createState() => _SmallScreenState();
}

class _SmallScreenState extends State<SmallScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                padding: const EdgeInsets.only(top: 32),
                width: double.infinity,
                child: _firstRow(context)),
            const Gap(10),
            Container(
                width: double.infinity,
                height: 310,
                child: _secondRow(context)),
            const Gap(10),
            Container(
                width: double.infinity, height: 620, child: _thirdRow(context)),
            const Gap(10),
            Container(
                width: double.infinity,
                height: 620,
                child: _fourthRow(context)),
          ],
        ),
      ),
    );
  }

  Widget _firstRow(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
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
                      'total_income'.tr(context), // venit total
                      style:
                          CustomStyle.semibold14(color: CustomColor.greenGray),
                    ),
                  ],
                ),
              ),
            ),
            const Gap(8),
            Expanded(
              flex: 1,
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
                      'last_7_days'.tr(context), //În ultimele 7 zile
                      style:
                          CustomStyle.semibold14(color: CustomColor.greenGray),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const Gap(10),
        Row(
          children: [
            Expanded(
              flex: 1,
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
                      'last_12_days'.tr(context), // În ultimele 12 zile
                      style:
                          CustomStyle.semibold14(color: CustomColor.greenGray),
                    ),
                  ],
                ),
              ),
            ),
            const Gap(8),
            Expanded(
              flex: 1,
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
                      style:
                          CustomStyle.semibold14(color: CustomColor.greenGray),
                    ),
                  ],
                ),
              ),
            ),
          ],
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
                      child: Text(
                          'sales_evolution'.tr(context), // Evoluția vânzărilor
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
      ],
    );
  }

  Widget _thirdRow(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: _contentSection(
            height: 310,
            // width: context.width14,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  // 'Vânzări cat. de produse',
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
        ),
        const Gap(8),
        Expanded(
          child: _contentSection(
            height: 310,
            // width: context.width14,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  // 'Vânzări cat. de Parteneri',
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
        ),
      ],
    );
  }

  Widget _fourthRow(BuildContext context) {
    return Column(
      children: [
        Flexible(
          child: _contentSection(
            height: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'last_entries'.tr(context),
                  style: CustomStyle.medium20(color: CustomColor.greenGray),
                ),
                const Flexible(child: ItemStockChart()),
              ],
            ),
          ),
        ),
        const Gap(10),
        Flexible(
          child: _contentSection(
            height: double.infinity,
            child: BarChartCustom(
              // title: 'Intrări & Ieșiri în Primul Trimestru al Anului',
              title: 'entries_and_exits_for_first_quarter'.tr(context),
              incomeData: [3200, 7400, 5500],
              expensesData: [2000, 5000, 4000],
            ),
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
