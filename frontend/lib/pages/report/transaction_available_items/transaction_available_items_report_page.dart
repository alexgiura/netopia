import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/utils/responsiveness.dart';
import 'package:erp_frontend_v2/models/document/document_generate_model.dart';
import 'package:erp_frontend_v2/pages/document/document_generate_popup/widgets/document_generate_data_table.dart';
import 'package:erp_frontend_v2/pages/report/transaction_available_items/widgets/transaction_available_items_report_data_table.dart';
import 'package:erp_frontend_v2/providers/partner_provider.dart';
import 'package:erp_frontend_v2/services/report.dart';
import 'package:erp_frontend_v2/widgets/custom_header_widget.dart';
import 'package:erp_frontend_v2/widgets/filters/drop_down_filter/drop_down_filter.dart';
import 'package:flutter/material.dart';

class AvailableItemsReportPage extends StatefulWidget {
  final String documentTitle;
  final String? documentSubtitle;
  final int transactionId;
  const AvailableItemsReportPage(
      {super.key,
      required this.documentTitle,
      this.documentSubtitle,
      required this.transactionId});

  @override
  State<AvailableItemsReportPage> createState() =>
      _AvailableItemsReportPageState();
}

class _AvailableItemsReportPageState extends State<AvailableItemsReportPage> {
  bool _isLoading = false;
  List<DocumentGenerate> _docs = [];
  List<String> _partners = [];
  late int _transactionId;

  @override
  void initState() {
    super.initState();
    _transactionId = widget.transactionId;
    _fetchDocuments();
  }

  Future<void> _fetchDocuments() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final reportService = ReportService();
      final docs = await reportService.getTransactionAvailableItems(
          partners: _partners, transactionId: _transactionId);
      // final minimumDelayFuture =
      //     Future.delayed(const Duration(milliseconds: 200));

      // final results = await Future.wait([fetchDocsFuture, minimumDelayFuture]);
      // final docs = results[0] as List<DocumentGenerate>;

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
                  _partners =
                      selectedList.map((partner) => partner.id!).toList();
                  _fetchDocuments();
                },
                provider: partnerProvider,
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
                : TransactionAvailableItemsDataTable(data: _docs),
          )
        ],
      ),
    );
  }
}
