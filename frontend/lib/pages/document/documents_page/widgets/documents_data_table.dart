import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/models/document/document_model.dart';
import 'package:erp_frontend_v2/models/document/documents_filter_model.dart';
import 'package:erp_frontend_v2/widgets/eFactura/eFactura_widget.dart';
import 'package:erp_frontend_v2/providers/document/document_provider.dart';
import 'package:erp_frontend_v2/providers/partner_provider.dart';
import 'package:erp_frontend_v2/widgets/buttons/edit_button.dart';
import 'package:erp_frontend_v2/widgets/buttons/icon_button.dart';
import 'package:erp_frontend_v2/widgets/buttons/primary_button.dart';
import 'package:erp_frontend_v2/widgets/custom_data_table.dart';
import 'package:erp_frontend_v2/widgets/custom_search_bar.dart';
import 'package:erp_frontend_v2/widgets/custom_status_chip.dart';
import 'package:erp_frontend_v2/widgets/custom_tab_bar.dart';
import 'package:erp_frontend_v2/widgets/dialog_widgets/custom_toast.dart';
import 'package:erp_frontend_v2/widgets/filters/date_interval_picker/date_picker_widget.dart';
import 'package:erp_frontend_v2/widgets/filters/drop_down_filter/drop_down_filter.dart';
import 'package:erp_frontend_v2/widgets/filters/sort_widget.dart';
import 'package:erp_frontend_v2/widgets/snack_bar/documents_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:toastification/toastification.dart';
import '../../../../constants/style.dart';
import '../../../../routing/router.dart';
import 'package:go_router/go_router.dart';

// Declare it globally, outside any class
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class DocumentsDataTable extends ConsumerStatefulWidget {
  const DocumentsDataTable({super.key, required this.documentTypeId});
  final int documentTypeId;

  @override
  ConsumerState<DocumentsDataTable> createState() => _DocumentsDataTableState();
}

class _DocumentsDataTableState extends ConsumerState<DocumentsDataTable>
    with SingleTickerProviderStateMixin, RouteAware {
  final GlobalKey<CustomDataTableState> _customDataTableKey =
      GlobalKey<CustomDataTableState>();

  DocumentFilter _documentFilter = DocumentFilter.empty();
  String? _searchText;

  List<bool> _selectStatus = [];

  List<int> selectedRows = [];
  GoRouter? _router;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _router = GoRouter.of(context);
      _router?.addListener(_onRouteChange);
    });

    _activeItems();

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

    Future.microtask(() => ref
        .read(documentNotifierProvider.notifier)
        .updateFilter(_documentFilter));
  }

  void _allItems() {
    setState(() {
      _selectStatus.add(true);
      _selectStatus.add(false);
    });
  }

  void _activeItems() {
    setState(() {
      _selectStatus.clear();
      _selectStatus.add(true);
    });
  }

  void _inactiveItems() {
    setState(() {
      _selectStatus.clear();
      _selectStatus.clear();
      _selectStatus.add(false);
    });
  }

  @override
  void dispose() {
    _router?.removeListener(_onRouteChange);
    super.dispose();
  }

  void _onRouteChange() {
    _customDataTableKey.currentState?.deselectAllRows();
  }

  @override
  Widget build(BuildContext context) {
    final documentState = ref.watch(documentNotifierProvider);

    return documentState.when(
      skipLoadingOnReload: true,
      skipLoadingOnRefresh: true,
      data: (documentList) {
        return Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: CustomStyle.customContainerDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTabBar(
                    tabs: [
                      Text('valid_feminin'.tr(context)),
                      Text('canceled'.tr(context)),
                      Text('all_feminin'.tr(context)),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectStatus.clear();
                        switch (value) {
                          case 0:
                            // 'Activi' tab is selected
                            _activeItems();
                            break;
                          case 1:
                            // 'Inactiv' tab is selected
                            _inactiveItems();
                            break;
                          case 2:
                            // 'All' tab is selected
                            _allItems();
                            break;
                        }
                      });
                    },
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
                      const Gap(8),
                      DropDownFilter(
                        labelText: 'partner'.tr(context),
                        onValueChanged: (selectedList) {
                          _documentFilter.partnerList = selectedList
                              .map((partner) => partner.id!)
                              .toList();
                          ref
                              .read(documentNotifierProvider.notifier)
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
                              .read(documentNotifierProvider.notifier)
                              .updateFilter(_documentFilter);
                        },
                        initialStartDate: _documentFilter.startDate,
                        initialEndDate: _documentFilter.endDate,
                      ),
                      CustomIconButton(
                        icon: Icons.refresh_rounded,
                        asyncOnPressed: () async {
                          ref
                              .read(documentNotifierProvider.notifier)
                              .refreshDocuments();
                        },
                      ),

                      const Spacer(),
                      // const SelectColumns()
                    ],
                  ),
                  const Gap(24),
                  Flexible(
                    child: CustomDataTable(
                      key: _customDataTableKey,
                      columns: getColumns(context, widget.documentTypeId),
                      rows: getRows(documentList),
                      showCheckBoxColumn: true,
                      showPagination: true,
                      keyColumnIndex: 0,
                      hiddenColumnIndices: [0],
                      onRowSelect: (selectedIds) {
                        showCustomSnackBar(
                          ref: ref,
                          context,
                          selectedIds: selectedIds,
                          onClose: () {
                            _customDataTableKey.currentState?.deselectAllRows();
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
      loading: () {
        return const CircularProgressIndicator();
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
      Document document = row.value;
      return DataRow2(
        cells: [
          DataCell(Text(document.hId ?? '')),
          DataCell(Text(document.series ?? '')),
          DataCell(Text(document.number)),
          DataCell(Text(document.date)),
          DataCell(Text(document.partner!.name)),
          DataCell(
            Row(
              children: [
                document.isDeleted == true
                    ? CustomStatusChip(
                        type: StatusType.error,
                        label: 'canceled_masculin'.tr(context))
                    : CustomStatusChip(
                        type: StatusType.success,
                        label: 'valid_masculin'.tr(context)),
              ],
            ),
          ),
          if (widget.documentTypeId == 2)
            DataCell(eFacturaWidget(row.value, context, ref)),
          DataCell(Container(
            alignment: Alignment.center,
            child: CustomEditButton(
              onTap: () {
                final routeName =
                    getDetailsRouteNameByDocumentType(widget.documentTypeId);
                context.goNamed(
                  routeName,
                  pathParameters: {'id1': row.value.hId!},
                );
              },
            ),
          )),
        ],
      );
    }).toList();
  }
}

List<DataColumn2> getColumns(BuildContext context, int documentType) {
  return [
    DataColumn2(
      label: Text('hId'.tr(context),
          style: CustomStyle.semibold16(color: CustomColor.greenGray)),
      size: ColumnSize.S,
    ),
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
      label: Text('status'.tr(context),
          style: CustomStyle.semibold16(color: CustomColor.greenGray)),
      size: ColumnSize.S,
    ),
    if (documentType == 2)
      DataColumn2(
        label: Text('e_factura'.tr(context),
            style: CustomStyle.semibold16(color: CustomColor.greenGray)),
        size: ColumnSize.S,
      ),
    DataColumn2(
        label: Container(
            alignment: Alignment.center,
            child: Text(
              'details'.tr(context),
              style: CustomStyle.semibold16(color: CustomColor.greenGray),
            )),
        fixedWidth: 60),
  ];
}
