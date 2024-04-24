class ReportFilter {
  DateTime startDate;
  DateTime endDate;
  List<String>? partnerList;

  ReportFilter({
    required this.startDate,
    required this.endDate,
    this.partnerList,
  });

  ReportFilter.empty()
      : startDate = DateTime.now(),
        endDate = DateTime.now(),
        partnerList = [];
}
