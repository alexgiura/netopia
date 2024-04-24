import 'package:erp_frontend_v2/models/document/document_model.dart';

class DocumentGenerate {
  String hId;
  String? series;
  String number;
  String date;
  DocumentItem documentItem;

  DocumentGenerate(
      {required this.hId,
      required this.number,
      required this.date,
      required this.documentItem,
      this.series,
      t});

  factory DocumentGenerate.fromJson(Map<String, dynamic> json) {
    return DocumentGenerate(
      hId: json['h_id'],
      series: json['series'],
      number: json['number'],
      date: json['date'],
      documentItem: DocumentItem.fromJson(json['document_item']),
    );
  }
}
