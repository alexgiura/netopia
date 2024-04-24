class DocumentFilter {
  int documentTypeId;
  DateTime startDate;
  DateTime endDate;
  String? status;
  List<String>? partnerList;

  DocumentFilter({
    required this.documentTypeId,
    required this.startDate,
    required this.endDate,
    this.status,
    this.partnerList,
  });

  DocumentFilter.empty()
      : documentTypeId = 0,
        startDate = DateTime.now(),
        endDate = DateTime.now(),
        partnerList = [];
}

// class DocumentFilter2 {
//   int? documentTypeId;
//   DateTime? startDate;
//   DateTime? endDate;
//   String? searchText;
//   String? number;
//   List<String> partner;

//   DocumentFilter2({
//     required this.documentTypeId,
//     required this.startDate,
//     required this.endDate,
//     required this.searchText,
//     required this.number,
//     required this.partner,
//   });

//   DocumentFilter2.empty()
//       : documentTypeId = null,
//         startDate = null,
//         endDate = null,
//         searchText = null,
//         number = null,
//         partner = [];
// }
