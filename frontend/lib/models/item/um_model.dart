class Um {
  int id;
  String name;

  Um({
    required this.id,
    required this.name,
  });

  Um.empty()
      : id = 0,
        name = '';

  factory Um.fromJson(Map<String, dynamic> json) {
    return Um(
      id: json['id'],
      name: json['name'],
    );
  }
}
