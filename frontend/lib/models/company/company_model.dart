class Company {
  String id;
  String name;
  String vatNumber;
  String? registrationNumber;
  String address;
  String? email;
  String? bankName;
  String? bankAccount;

  Company({
    required this.id,
    required this.name,
    required this.vatNumber,
    required this.address,
    this.email,
    this.registrationNumber,
    this.bankName,
    this.bankAccount,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      name: json['name'],
      vatNumber: json['vat_number'],
      registrationNumber: json['registration_number'],
      address: json['address'],
      email: json['email'],
      bankName: json['bank_name'],
      bankAccount: json['bank_account'],
    );
  }
}
