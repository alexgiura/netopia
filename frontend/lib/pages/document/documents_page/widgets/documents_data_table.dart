import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/models/document/document_model.dart';
import 'package:erp_frontend_v2/models/document/documents_filter_model.dart';
import 'package:erp_frontend_v2/providers/document_providers.dart';
import 'package:erp_frontend_v2/providers/partner_provider.dart';
import 'package:erp_frontend_v2/widgets/buttons/edit_button.dart';
import 'package:erp_frontend_v2/widgets/buttons/primary_button.dart';
import 'package:erp_frontend_v2/widgets/custom_data_table.dart';
import 'package:erp_frontend_v2/widgets/custom_search_bar.dart';
import 'package:erp_frontend_v2/widgets/custom_tab_bar.dart';
import 'package:erp_frontend_v2/widgets/filters/date_interval_picker/date_picker_widget.dart';
import 'package:erp_frontend_v2/widgets/filters/drop_down_filter/drop_down_filter.dart';
import 'package:erp_frontend_v2/widgets/filters/sort_widget.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import '../../../../constants/style.dart';
import '../../../../routing/router.dart';
import 'package:go_router/go_router.dart';

class DocumentsDataTable extends ConsumerStatefulWidget {
  const DocumentsDataTable(
      {super.key, required this.documentTypeId, this.status});
  //final List<DocumentLight>? data;
  final int documentTypeId;
  final String? status;

  @override
  ConsumerState<DocumentsDataTable> createState() => _DocumentsDataTableState();
}

class _DocumentsDataTableState extends ConsumerState<DocumentsDataTable>
    with SingleTickerProviderStateMixin {
  String selectedHid = '';
  DocumentFilter _documentFilter = DocumentFilter.empty();
  String? _searchText;
  bool showLoadingButton = false;
  late TabController _tabController;
  List<bool> _selectStatus = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _selectStatus.add(true);
    _tabController.addListener(() {
      int selectedIndex = _tabController.index;
      // Check if the index is already being processed
      if (_tabController.indexIsChanging) {
        return;
      }
      setState(() {
        _selectStatus.clear();
        switch (selectedIndex) {
          case 0:
            // 'Activi' tab is selected
            _selectStatus.add(true);
            break;
          case 1:
            // 'Inactiv' tab is selected
            _selectStatus.add(false);
            break;
          case 2:
            // 'All' tab is selected
            _selectStatus.add(true);
            _selectStatus.add(false);
            break;
        }
      });
    });

    DateTime now = DateTime.now();
    int currentDayOfWeek = now.weekday;
    DateTime startOfWeek =
        now.subtract(Duration(days: currentDayOfWeek - DateTime.monday));
    DateTime endOfWeek =
        now.add(Duration(days: DateTime.sunday - currentDayOfWeek));

    _documentFilter = DocumentFilter(
      documentTypeId: widget.documentTypeId,
      startDate: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day),
      endDate: DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day),
    );

    Future.microtask(() =>
        ref.read(documentProvider.notifier).updateFilter(_documentFilter));
  }

  @override
  Widget build(BuildContext context) {
    final documentState = ref.watch(documentProvider);

    return documentState.when(
      skipLoadingOnReload: true,
      skipLoadingOnRefresh: true,
      data: (documentList) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: CustomStyle.customContainerDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTabBar(
                tabController: _tabController,
                tabs: [
                  Tab(
                    child: Text(
                      'valid'.tr(context),
                      style: CustomStyle.regular16(),
                    ),
                    // text: 'valid'.tr(context),
                  ),
                  Tab(
                    child: Text(
                      'canceled'.tr(context),
                    ),
                    // text: 'canceled'.tr(context),
                  ),
                  Tab(
                    text: 'all'.tr(context),
                  ),
                ],
              ),
              const Gap(24),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 4,
                    child: CustomSearchBar(
                      hintText: 'document_hint_search'.tr(context),
                      initialValue: _searchText,
                      onValueChanged: (value) {
                        setState(() {
                          _searchText = value;
                        });
                      },
                    ),
                  ),
                  Gap(8),
                  DropDownFilter(
                    labelText: 'partner'.tr(context),
                    onValueChanged: (selectedList) {
                      _documentFilter.partnerList =
                          selectedList.map((partner) => partner.id!).toList();
                      ref
                          .read(documentProvider.notifier)
                          .updateFilter(_documentFilter);
                    },
                    provider: partnerProvider,
                  ),
                  const Gap(8),
                  DateIntervalPickerFilter(
                    labelText: 'date'.tr(context),
                    onValueChanged: (startDate, endDate) {
                      _documentFilter.startDate = startDate;
                      _documentFilter.endDate = endDate;

                      ref
                          .read(documentProvider.notifier)
                          .updateFilter(_documentFilter);
                    },
                    initialStartDate: _documentFilter.startDate,
                    initialEndDate: _documentFilter.endDate,
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.refresh_rounded,
                      color: CustomColor.textPrimary,
                    ),
                    onPressed: () {
                      ref.read(documentProvider.notifier).refreshDocuments();
                    },
                  ),
                  const Spacer(),
                  const SelectColumns()
                ],
              ),
              const Gap(24),
              Flexible(
                child: CustomDataTable(
                  columns: getColumns(context),
                  rows: getRows(documentList),
                ),
              ),
            ],
          ),
        );
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      error: (error, stackTrace) {
        return Text("Error: $error");
      },
    );
  }

  List<DataRow2> getRows(List<Document> data) {
    List<Document> filteredData = data.where((row) {
      bool statusMatch = _selectStatus.isEmpty ||
          _selectStatus.contains(!(row.isDeleted ?? false));

      bool searchTextMatch = _searchText == null ||
          _searchText!.isEmpty ||
          (row.series?.toLowerCase() ?? '')
              .contains(_searchText!.toLowerCase()) ||
          row.number.toLowerCase().contains(_searchText!.toLowerCase());
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
              alignment: Alignment.center,
              child: Container(
                height: 28,
                width: 70,
                decoration: BoxDecoration(
                  color: row.value.isDeleted == true
                      ? CustomColor.error.withOpacity(0.1)
                      : CustomColor.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: Text(row.value.isDeleted == true ? 'Anulat' : 'Valid',
                      style: row.value.isDeleted == true
                          ? CustomStyle.semibold14(color: CustomColor.error)
                          : CustomStyle.semibold14(color: CustomColor.green)),
                ),
              ),
            ),
          ),
          DataCell(SizedBox(
            child: Center(child: _eFacturaWidget(row.value, context)),
          )),
          DataCell(Container(
            alignment: Alignment.center,
            child: CustomEditButton(
              onTap: () {
                final routeName =
                    getDetailsRouteNameByDocumentType(widget.documentTypeId);
                context.goNamed(
                  routeName,
                  pathParameters: {'id1': row.value.hId},
                );
              },
            ),
          )),
        ],
      );
    }).toList();
  }

  Widget? _eFacturaWidget(Document document, BuildContext context) {
    if (document.isDeleted == true) {
      return null;
    } else if (document.efacturaStatus!.isEmpty) {
      return PrimaryButton(
          text: 'send'.tr(context),
          style: CustomStyle.primaryBlackButton,
          onPressed: () => _sendEfactura(context, document));
    } else if (document.efacturaStatus != null &&
        document.efacturaStatus == 'success') {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle_outline,
              color: CustomColor.greenText, size: 20),
          const Gap(10),
          Text('processed'.tr(context),
              style: CustomStyle.semibold14(color: CustomColor.greenText)),
        ],
      );
    } else if (document.efacturaStatus == 'error') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PrimaryButton(
            style: CustomStyle.primaryBlackButton,
            text: 'resend'.tr(context),
            asyncOnPressed: () async {
              return _sendEfactura(context, document);
            },
          ),
          const Gap(10),
          SvgPicture.asset(
            'assets/icons/error_outline.svg',
            height: 20,
            width: 20,
          )
        ],
      );
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

List<DataColumn2> getColumns(BuildContext context) {
  return [
    DataColumn2(
      label: Text('series'.tr(context),
          style: CustomStyle.semibold16(color: CustomColor.greenGray)),
      size: ColumnSize.S,
    ),
    DataColumn2(
      label: Text('number'.tr(context),
          style: CustomStyle.semibold16(color: CustomColor.greenGray)),
      size: ColumnSize.S,
    ),
    DataColumn2(
      label: Text('date'.tr(context),
          style: CustomStyle.semibold16(color: CustomColor.greenGray)),
      size: ColumnSize.S,
    ),
    DataColumn2(
      label: Text('partner'.tr(context),
          style: CustomStyle.semibold16(color: CustomColor.greenGray)),
      size: ColumnSize.L,
    ),
    DataColumn2(
      label: Container(
        alignment: Alignment.center,
        child: Text('status'.tr(context),
            style: CustomStyle.semibold16(color: CustomColor.greenGray)),
      ),
      size: ColumnSize.S,
    ),
    DataColumn2(
      label: Container(
        alignment: Alignment.center,
        child: Text('e_factura'.tr(context),
            style: CustomStyle.semibold16(color: CustomColor.greenGray)),
      ),
      size: ColumnSize.M,
    ),
    DataColumn2(
        label: Container(
            alignment: Alignment.center,
            child: Text(
              'edit'.tr(context),
              style: CustomStyle.semibold16(color: CustomColor.greenGray),
            )),
        fixedWidth: 100),
  ];
}
