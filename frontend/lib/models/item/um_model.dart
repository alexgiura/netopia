class Um {
  int? id;
  String name;
  String code;
  bool isActive;

  Um({this.id, required this.name, required this.code, required this.isActive});

  Um.empty()
      : id = null,
        name = '',
        code = '',
        isActive = true;

  factory Um.fromJson(Map<String, dynamic> json) {
    return Um(
        id: json['id'],
        name: json['name'],
        code: json['code'],
        isActive: json['is_active']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'is_active': isActive,
    };
  }
}
