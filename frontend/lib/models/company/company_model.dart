import 'package:erp_frontend_v2/models/address/address_model.dart';

class Company {
  String? id;
  String name;
  bool? vat;
  String vatNumber;
  String? registrationNumber;
  Address? address;

  // String? bankName;
  // String? bankAccount;

  Company({
    this.id,
    required this.name,
    required this.vatNumber,
    required this.address,
    this.vat,
    this.registrationNumber,

    // this.bankName,
    // this.bankAccount,
  });

  Company.empty()
      : id = null,
        name = '',
        vat = null,
        vatNumber = '',
        registrationNumber = null,
        address = Address.empty();

  // bankName = null,
  // bankAccount = null;

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      name: json['name'],
      vat: json['vat'],
      vatNumber: json['vat_number'],
      registrationNumber: json['registration_number'],
      address: json.containsKey('company_address')
          ? Address.fromJson(json['company_address'])
          : null,

      // bankName: json['bank_name'],
      // bankAccount: json['bank_account'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'vat': vat,
      'vat_number': vatNumber,
      'registration_number': registrationNumber,
      'company_address': address?.toJson(),
    };
  }
}
