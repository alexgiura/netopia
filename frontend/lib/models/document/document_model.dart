import 'package:erp_frontend_v2/models/partner/partner_model.dart';

import '../item/um_model.dart';
import '../item/vat_model.dart';

class Document {
  String hId;
  DocumentType documentType;
  String? series;
  String number;
  String date;
  Partner? partner;
  String? personId;
  int? recipeId;
  String? notes;
  bool? isDeleted;
  List<DocumentItem> documentItems;

  Document(
      {required this.hId,
      required this.documentType,
      required this.series,
      required this.number,
      required this.date,
      this.partner,
      required this.documentItems,
      this.personId,
      this.recipeId,
      this.notes,
      this.isDeleted});

  Document.empty()
      : hId = '',
        documentType = DocumentType.empty(),
        series = null,
        number = '',
        date = '',
        partner = null,
        personId = null,
        recipeId = null,
        notes = null,
        documentItems = [];

  bool isEmpty() {
    return hId.isEmpty;
  }

  factory Document.fromJson(Map<String, dynamic> json) {
    final List<dynamic>? itemsJson = json['document_items'];
    final List<DocumentItem> items = itemsJson != null
        ? itemsJson.map((item) => DocumentItem.fromJson(item)).toList()
        : [];

    return Document(
      hId: json['h_id'],
      documentType: DocumentType.fromJson(json['type'] as Map<String, dynamic>),
      series: json['series'],
      number: json['number'],
      date: json['date'],
      partner: Partner.fromJson(json['partner'] as Map<String, dynamic>),
      personId: json.containsKey('person_name') ? json['person_name'] : null,
      recipeId: json.containsKey('recipe_id') ? json['recipe_id'] : null,
      notes: json.containsKey('notes') ? json['notes'] : null,
      isDeleted: json['is_deleted'],
      documentItems: items,
    );
  }
}

class DocumentItem {
  String? dId;
  String id;
  String? code;
  String name;
  double quantity;
  Um um;
  double? price;
  Vat? vat;
  double? amountNet;
  double? amountVat;
  double? amountGross;
  List<String>? generatedDId;
  String? itemTypePn;

  DocumentItem({
    required this.id,
    this.code,
    required this.name,
    required this.quantity,
    required this.um,
    this.dId,
    this.price,
    this.vat,
    this.amountNet,
    this.amountVat,
    this.amountGross,
    this.generatedDId,
    this.itemTypePn,
  });
  DocumentItem.empty()
      : dId = '',
        id = '',
        code = '',
        name = '',
        quantity = 0.00,
        um = Um.empty(),
        price = null,
        vat = Vat.empty(),
        amountNet = null,
        amountVat = null,
        amountGross = null;

  factory DocumentItem.fromJson(Map<String, dynamic> json) {
    return DocumentItem(
      dId: json['d_id'],
      id: json['item_id'],
      code: json['item_code'],
      name: json['item_name'],
      quantity: json['quantity'],
      um: Um.fromJson(json['um']),
      price: json.containsKey('price') ? json['price'] : null,
      vat: json.containsKey('vat') ? Vat.fromJson(json['vat']) : null,
      amountNet: json.containsKey('amount_net') ? json['amount_net'] : null,
      amountVat: json.containsKey('amount_vat') ? json['amount_vat'] : null,
      amountGross:
          json.containsKey('amount_gross') ? json['amount_gross'] : null,
      itemTypePn:
          json.containsKey('item_type_pn') ? json['item_type_pn'] : null,
    );
  }
}

class DocumentType {
  int id;
  String nameRo;
  String nameEn;

  DocumentType({
    required this.id,
    required this.nameRo,
    required this.nameEn,
  });
  DocumentType.empty()
      : id = 0,
        nameRo = '',
        nameEn = '';

  factory DocumentType.fromJson(Map<String, dynamic> json) {
    return DocumentType(
      id: json['id'],
      nameRo: json['name_ro'],
      nameEn: json['name_en'],
    );
  }
}
