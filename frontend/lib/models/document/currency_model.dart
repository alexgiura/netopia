class Currency {
  int? id;
  String? name;
  bool isPrimary;

  Currency({
    required this.id,
    required this.name,
    required this.isPrimary,
  });

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      id: json['id'],
      name: json['name'],
      isPrimary: json['is_primary'],
    );
  }
}
