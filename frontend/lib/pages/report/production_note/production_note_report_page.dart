import 'dart:typed_data';

import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/helpers/responsiveness.dart';
import 'package:erp_frontend_v2/models/report/production_note_report_model.dart';
import 'package:erp_frontend_v2/models/report/report_filter_model.dart';
import 'package:erp_frontend_v2/pages/report/production_note/widgets/pdf_production_note_report.dart';
import 'package:erp_frontend_v2/pages/report/production_note/widgets/production_note_report_data_table.dart';
import 'package:erp_frontend_v2/pdf/pdf_viewer.dart';
import 'package:erp_frontend_v2/providers/partner_provider.dart';
import 'package:erp_frontend_v2/services/report.dart';
import 'package:erp_frontend_v2/widgets/buttons/primary_button.dart';
import 'package:erp_frontend_v2/widgets/custom_header_widget.dart';
import 'package:erp_frontend_v2/widgets/filter_section/filter_section_large_report.dart';
import 'package:erp_frontend_v2/widgets/filters/date_interval_picker/date_picker_widget.dart';
import 'package:erp_frontend_v2/widgets/filters/drop_down_filter/drop_down_filter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:html' as html;

class ProductionNoteReportPage extends StatefulWidget {
  final String documentTitle;
  final String? documentSubtitle;
  const ProductionNoteReportPage({
    super.key,
    required this.documentTitle,
    this.documentSubtitle,
  });

  @override
  State<ProductionNoteReportPage> createState() =>
      _ProductionNoteReportPageState();
}

class _ProductionNoteReportPageState extends State<ProductionNoteReportPage> {
  bool _isLoading = false;

  List<ProductionNoteReport> _docs = [];
  //Uint8List _uint8List = Uint8List(0);
  late ReportFilter _reportFilter = ReportFilter.empty();

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    int currentDayOfWeek = now.weekday;

    DateTime startOfWeek =
        now.subtract(Duration(days: currentDayOfWeek - DateTime.monday));
    DateTime endOfWeek =
        now.add(Duration(days: DateTime.sunday - currentDayOfWeek));

    _reportFilter = ReportFilter(
      startDate: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day),
      endDate: DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day),
    );
    _fetchDocuments();
  }

  Future<void> _fetchDocuments() async {
    setState(() {
      _isLoading = true;
    });

    final reportService = ReportService();
    final fetchDocsFuture =
        reportService.getProductionNoteReport(reportFilter: _reportFilter);
    final minimumDelayFuture =
        Future.delayed(const Duration(milliseconds: 500));

    try {
      final results = await Future.wait([fetchDocsFuture, minimumDelayFuture]);
      final docs = results[0] as List<ProductionNoteReport>;

      setState(() {
        _docs = docs;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomColor.white,
      padding: EdgeInsets.only(
        left: ResponsiveWidget.isSmallScreen(context) ? 16 : 24,
        right: ResponsiveWidget.isSmallScreen(context) ? 16 : 24,
        top: ResponsiveWidget.isSmallScreen(context) ? 32 : 32,
        bottom: ResponsiveWidget.isSmallScreen(context) ? 16 : 24,
      ),
      child: Column(
        children: [
          Row(
            children: [
              CustomHeader(
                title: widget.documentTitle,
                subtitle: widget.documentSubtitle,
              ),
              const Spacer(),
              PrimaryButton(
                text: 'Printeaza',
                icon: Icons.file_download,
                onPressed: () async {
                  await PdfProductionNoteReport.generate(
                    _docs,
                    DateFormat('yyyy/MM/dd').format(_reportFilter.startDate),
                    DateFormat('yyyy/MM/dd').format(_reportFilter.endDate),
                  ).then((value) {
                    final blob = html.Blob([value], 'application/pdf');
                    final url = html.Url.createObjectUrlFromBlob(blob);

                    html.window.open(url, '_blank');
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 36),

          //Filters
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              DropDownFilter(
                labelText: 'Partener',
                onValueChanged: (selectedList) {
                  _reportFilter.partnerList =
                      selectedList.map((partner) => partner.id!).toList();
                  _fetchDocuments();
                },
                provider: partnerProvider,
              ),
              const SizedBox(
                width: 8,
              ),
              DateIntervalPickerFilter(
                labelText: 'Data',
                onValueChanged: (startDate, endDate) {
                  _reportFilter.startDate = startDate;
                  _reportFilter.endDate = endDate;
                  _fetchDocuments();
                },
                initialStartDate: _reportFilter.startDate,
                initialEndDate: _reportFilter.endDate,
              ),
              const SizedBox(
                width: 8,
              ),
              IconButton(
                icon: const Icon(
                  Icons.refresh_rounded,
                  color: CustomColor.active,
                ),
                onPressed: () {
                  _fetchDocuments();
                },
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 8),
          // Data Table
          Expanded(
              child: _isLoading == true
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ProductionNoteReportPageDataTable(data: _docs))
        ],
      ),
    );
  }
}
