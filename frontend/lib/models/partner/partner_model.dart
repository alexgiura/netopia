class Partner {
  String? id;
  String? code;
  String name;
  String type;
  String? taxId;
  String? companyNumber;
  String? personalId;
  bool isActive;

  Partner(
      {this.id,
      this.code,
      required this.name,
      required this.type,
      required this.taxId,
      required this.companyNumber,
      required this.personalId,
      required this.isActive});
  Partner.empty()
      : id = null,
        code = null,
        name = '',
        type = '',
        taxId = null,
        companyNumber = null,
        personalId = null,
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
        taxId: json['tax_id'],
        companyNumber: json['company_number'],
        personalId: json['personal_id'],
        isActive: json['is_active']);
  }
}
