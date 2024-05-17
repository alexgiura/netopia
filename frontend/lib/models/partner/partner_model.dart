class Partner {
  String? id;
  String? code;
  String name;
  String type;
  bool? vat;
  String? vatNumber;
  String? registrationNumber;
  String? individualNumber;
  bool isActive;

  Partner(
      {this.id,
      this.code,
      required this.name,
      required this.type,
      required this.vat,
      required this.vatNumber,
      required this.registrationNumber,
      required this.individualNumber,
      required this.isActive});
  Partner.empty()
      : id = null,
        code = null,
        name = '',
        type = '',
        vat = false,
        vatNumber = null,
        registrationNumber = null,
        individualNumber = null,
        isActive = true;
  bool isEmpty() {
    return id == null;
  }

  factory Partner.fromJson(Map<String, dynamic> json) {
    return Partner(
        id: json['id'],
        code: json['code'],
        name: json['name'],
        type: json['type'],
        vat: json['vat'],
        vatNumber: json['vat_number'],
        registrationNumber: json['registration_number'],
        individualNumber: json['individual_number'],
        isActive: json['active']);
  }
}
