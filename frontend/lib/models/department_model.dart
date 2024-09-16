class Department {
  int? id;
  String name;
  int flags;
  List<Department> parents;

  Department(
      {this.id,
      required this.name,
      required this.flags,
      required this.parents});

  Department.empty()
      : id = null,
        name = '',
        flags = 1,
        parents = [];

  factory Department.fromJson(Map<String, dynamic> json) {
    final List<dynamic>? partnerJson =
        json.containsKey('parents') ? json['parents'] : null;

    final List<Department> departments = partnerJson != null
        ? partnerJson.map((item) => Department.fromJson(item)).toList()
        : [];
    return Department(
      id: json['id'],
      name: json['name'],
      flags: json['flags'],
      parents: departments,
    );
  }
}
