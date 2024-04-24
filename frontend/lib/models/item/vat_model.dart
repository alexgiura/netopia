class Vat {
  int id;
  String name;
  double percent;

  Vat({
    required this.id,
    required this.name,
    required this.percent,
  });

  Vat.empty()
      : id = 0,
        name = '',
        percent = 0.00;

  factory Vat.fromJson(Map<String, dynamic> json) {
    return Vat(
      id: json['id'],
      name: json['name'],
      percent: json['percent'],
    );
  }
}
