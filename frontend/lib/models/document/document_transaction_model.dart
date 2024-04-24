class DocumentTransaction {
  int id;
  String name;
  int documentTypeSourceId;
  int documentTypeDestinationId;

  DocumentTransaction({
    required this.id,
    required this.name,
    required this.documentTypeSourceId,
    required this.documentTypeDestinationId,
  });

  factory DocumentTransaction.fromJson(Map<String, dynamic> json) {
    return DocumentTransaction(
      id: json['id'],
      name: json['name'],
      documentTypeSourceId: json['document_type_source_id'],
      documentTypeDestinationId: json['document_type_destination_id'],
    );
  }
}
