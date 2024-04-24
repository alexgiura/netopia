// ignore: unused_import
import 'package:erp_frontend_v2/models/partner/partner_model.dart';

class DocumentLight {
  String hId;
  String? series;
  String number;
  String date;
  String partner;
  bool? isDeleted;
  String? status;

  DocumentLight({
    required this.hId,
    required this.series,
    required this.number,
    required this.date,
    required this.partner,
    this.isDeleted,
    this.status,
  });

  // DocumentLight.empty()
  //     : hId = '',
  //       documentType = DocumentType.empty(),
  //       series = null,
  //       number = '',
  //       date = '',
  //       partner = Partner.empty(),
  //       personId = null,
  //       recipeId = null,
  //       notes = null,
  //       documentItems = [];

  // bool isEmpty() {
  //   return hId.isEmpty;
  // }

  factory DocumentLight.fromJson(Map<String, dynamic> json) {
    return DocumentLight(
        hId: json['h_id'],
        series: json['series'],
        number: json['number'],
        date: json['date'],
        partner: json['partner'],
        isDeleted: json['is_deleted'],
        status: json['status']);
  }
}
