import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/models/document/document_model.dart';
import 'package:erp_frontend_v2/models/document/documents_filter_model.dart';
import 'package:erp_frontend_v2/providers/document_providers.dart';
import 'package:erp_frontend_v2/providers/partner_provider.dart';
import 'package:erp_frontend_v2/widgets/buttons/primary_button.dart';
import 'package:erp_frontend_v2/widgets/custom_data_table.dart';
import 'package:erp_frontend_v2/widgets/filters/date_interval_picker/date_picker_widget.dart';
import 'package:erp_frontend_v2/widgets/filters/drop_down_filter/drop_down_filter.dart';
import 'package:erp_frontend_v2/widgets/filters/sort_widget.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../constants/style.dart';
import '../../../../routing/router.dart';
import 'package:go_router/go_router.dart';

class DocumentsDataTable extends ConsumerStatefulWidget {
  const DocumentsDataTable(
      {super.key, required this.documentTypeId, this.status, this.searchText});
  //final List<DocumentLight>? data;
  final int documentTypeId;
  final String? status;
  final String? searchText;

  @override
  ConsumerState<DocumentsDataTable> createState() => _DocumentsDataTableState();
}

class _DocumentsDataTableState extends ConsumerState<DocumentsDataTable> {
  String selectedHid = '';
  DocumentFilter _documentFilter = DocumentFilter.empty();
  bool showLoadingButton = false;

  @override
  void initState() {
    super.initState();

    DateTime now = DateTime.now();
    int currentDayOfWeek = now.weekday;

    // Assuming the week starts on Monday (with `DateTime.monday` equals 1)
    // and ends on Sunday (with `DateTime.sunday` equals 7)
    DateTime startOfWeek =
        now.subtract(Duration(days: currentDayOfWeek - DateTime.monday));
    DateTime endOfWeek =
        now.add(Duration(days: DateTime.sunday - currentDayOfWeek));

    // Set the start and end of the week as the default dates
    _documentFilter = DocumentFilter(
      documentTypeId: widget.documentTypeId,
      startDate: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day),
      endDate: DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day),
    );

    Future.microtask(() =>
        ref.read(documentProvider.notifier).updateFilter(_documentFilter));

    // _fetchDocuments();
  }

  @override
  Widget build(BuildContext context) {
    final documentState = ref.watch(documentProvider);
    //ref.read(documentProvider.notifier).updateFilter(_documentFilter);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            DropDownFilter(
              labelText: 'Partener',
              onValueChanged: (selectedList) {
                _documentFilter.partnerList =
                    selectedList.map((partner) => partner.id!).toList();
                ref
                    .read(documentProvider.notifier)
                    .updateFilter(_documentFilter);
              },
              provider: partnerProvider,
            ),
            const SizedBox(
              width: 8,
            ),
            DateIntervalPickerFilter(
              labelText: 'Data',
              onValueChanged: (startDate, endDate) {
                _documentFilter.startDate = startDate;
                _documentFilter.endDate = endDate;

                ref
                    .read(documentProvider.notifier)
                    .updateFilter(_documentFilter);
                //_fetchDocuments();
              },
              initialStartDate: _documentFilter.startDate,
              initialEndDate: _documentFilter.endDate,
            ),
            const SizedBox(
              width: 8,
            ),
            IconButton(
              icon: Icon(
                Icons.refresh_rounded,
                color: CustomColor.active,
              ), // You can change the icon as needed
              onPressed: () {
                // Handle refresh logic here
                // _fetchDocuments();
              },
            ),
            Spacer(),
            SelectColumns()
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Expanded(
          child: Container(
            decoration: CustomStyle.customContainerDecoration,
            child: documentState.when(
              data: (documentList) {
                return CustomDataTable(
                    columns: _columns, rows: getRows(documentList));
              },
              loading: () {
                // Show a progress indicator while loading
                return Center(
                  child:
                      CircularProgressIndicator(), // You can customize this indicator
                );
              },
              error: (error, stackTrace) {
                // Handle the case when the future encounters an error
                return Text("Error: $error");
              },
            ),
          ),
        ),
      ],
    );
  }

  List<DataRow2> getRows(List<Document> data) {
    // Filter data based on widget.status and widget.searchText
    List<Document> filteredData = data.where((row) {
      bool statusMatch = widget.status == null;
      // || row.status == widget.status;
      bool searchTextMatch = widget.searchText == null ||
          widget.searchText!.isEmpty ||
          (row.series?.toLowerCase() ?? '')
              .contains(widget.searchText!.toLowerCase()) ||
          row.number.toLowerCase().contains(widget.searchText!.toLowerCase());
      return statusMatch && searchTextMatch;
    }).toList();

    return filteredData.asMap().entries.map((row) {
      return DataRow2(
        cells: [
          DataCell(Text(row.value.series ?? '')),
          DataCell(Text(row.value.number)),
          DataCell(Text(row.value.date)),
          DataCell(Text(row.value.partner!.name)),
          DataCell(
            Container(
              decoration: BoxDecoration(
                color: row.value.isDeleted == true
                    ? Colors.red
                    : CustomColor.active,
                borderRadius: CustomStyle.customBorderRadius,
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Text(row.value.isDeleted == true ? 'Anulat' : 'Valid',
                  style: CustomStyle.tagText),
            ),
          ),
          DataCell(SizedBox(
            child: _eFacturaWidget(row.value, context),
          )),
          DataCell(
            IconButton(
              hoverColor: CustomColor.lightest,
              splashRadius: 22,
              icon: const Icon(Icons.edit_outlined,
                  color: CustomColor
                      .active), // Replace with your desired edit icon
              onPressed: () {
                final routeName =
                    getDetailsRouteNameByDocumentType(widget.documentTypeId);
                context.goNamed(
                  routeName,
                  pathParameters: {'id1': row.value.hId},
                  //extra: {'document': row.value}
                );
              },
            ),
          ),
        ],
      );
    }).toList();
  }

  Widget? _eFacturaWidget(Document document, BuildContext context) {
    if (document.efacturaStatus == null || document.isDeleted == true) {
      return null;
    } else if (document.efacturaStatus == null) {
      return PrimaryButton(
          text: 'send'.tr(context),
          onPressed: () => _sendEfactura(context, document));
    } else if (document.efacturaStatus != null) {
      return Row(
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: CustomColor.greenText,
          ),
          Text('Procesat',
              style: CustomStyle.labelSemibold14(color: CustomColor.greenText)),
        ],
      );
    } else if (document.efacturaStatus != null ||
        document.efacturaStatus == 'error' ||
        document.efacturaStatus == 'neprocesat') {
      return PrimaryButton(
          text: "resend".tr(context),
          onPressed: () => _sendEfactura(context, document));
    }
  }

  void _sendEfactura(BuildContext context, Document document) {
    // Send eFactura
    // activate the loading indicator
    setState(() {
      showLoadingButton = true;
    });
    // Call the API to send the eFactura
    // If the API call is successful, update the document with the new eFactura status

  }
}

List<DataColumn2> _columns = const [
  DataColumn2(
    label: Text('Serie'),
    size: ColumnSize.S,
  ),
  DataColumn2(
    label: Text('Număr'),
    size: ColumnSize.S,
  ),
  DataColumn2(
    label: Text('Dată'),
    size: ColumnSize.S,
  ),
  DataColumn2(
    label: Text('Partener'),
    size: ColumnSize.L,
  ),
  DataColumn2(
    label: Text('Stare'),
    size: ColumnSize.S,
  ),
  DataColumn2(
    label: Text('e-Factura'),
    size: ColumnSize.M,
  ),
  DataColumn2(label: Text('Editează'), fixedWidth: 100),
];
