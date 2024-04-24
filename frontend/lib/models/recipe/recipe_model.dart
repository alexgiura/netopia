import 'package:erp_frontend_v2/models/document/document_model.dart';

class Recipe {
  int? id;
  String name;
  bool isActive;
  List<DocumentItem> documentItems;

  Recipe(
      {required this.id,
      required this.name,
      required this.isActive,
      required this.documentItems});

  Recipe.empty()
      : id = null,
        name = '',
        isActive = true,
        documentItems = [];

  bool isEmpty() {
    return id == null;
  }

  factory Recipe.fromJson(Map<String, dynamic> json) {
    final List<dynamic>? itemsJson = json['document_items'];
    final List<DocumentItem> items = itemsJson != null
        ? itemsJson.map((item) => DocumentItem.fromJson(item)).toList()
        : [];
    return Recipe(
        id: json['id'],
        name: json['name'],
        isActive: json['is_active'],
        documentItems: items);
  }
}
