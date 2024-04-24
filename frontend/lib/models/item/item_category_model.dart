class ItemCategory {
  int? id;
  String name;
  bool isActive;
  bool? generatePn;

  ItemCategory({
    required this.id,
    required this.name,
    required this.isActive,
    this.generatePn,
  });

  ItemCategory.empty()
      : id = null,
        name = '',
        isActive = true,
        generatePn = false;

  bool isEmpty() {
    return id == null;
  }

  factory ItemCategory.fromJson(Map<String, dynamic> json) {
    return ItemCategory(
      id: json['id'],
      name: json['name'],
      isActive: json['is_active'],
      generatePn: json.containsKey('generate_pn') ? json['generate_pn'] : null,
    );
  }
}
