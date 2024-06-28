import 'package:flutter/foundation.dart';

import 'item_category_model.dart';
import 'um_model.dart';
import 'vat_model.dart';

class Item {
  String? id;
  String? code;
  String name;
  bool isActive;
  bool? isStock;
  Um um;
  Vat vat;
  ItemCategory? category;

  Item({
    this.id,
    this.code,
    required this.name,
    required this.isActive,
    required this.isStock,
    required this.um,
    required this.vat,
    this.category,
  });

  Item.empty()
      : id = null,
        code = null,
        name = '',
        isActive = true,
        isStock = true,
        um = Um.empty(),
        vat = Vat.empty();

  bool isEmpty() {
    return id == null;
  }

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
        id: json['id'],
        code: json.containsKey('code') ? json['code'] : null,
        name: json['name'],
        isActive: json.containsKey('is_active') ? json['is_active'] : null,
        isStock: json.containsKey('is_stock') ? json['is_stock'] : null,
        um: Um.fromJson(json['um']),
        vat: Vat.fromJson(json['vat']),
        category: json['category'] == null
            ? null
            : ItemCategory.fromJson(json['category']));
  }
}
