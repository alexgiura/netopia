class DocumentGenerateFilter {
  String? partnerId;
  int? documentTypeId;
  String? date;
  int? transactionId;

  DocumentGenerateFilter({
    required this.partnerId,
    required this.documentTypeId,
    required this.date,
    required this.transactionId,
  });

  DocumentGenerateFilter.empty()
      : partnerId = null,
        documentTypeId = null,
        date = null,
        transactionId = null;
}
