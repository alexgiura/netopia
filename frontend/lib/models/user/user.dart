import 'package:erp_frontend_v2/models/company/company_model.dart';

class User {
  User({
    required this.id,
    this.email,
    this.phoneNumber,
    this.company,
    this.eFacturaAuth = false,
  });

  String id;
  String? email;
  String? phoneNumber;
  Company? company;
  bool eFacturaAuth;

  User.empty()
      : id = '',
        email = '',
        phoneNumber = null,
        company = Company.empty(),
        eFacturaAuth = false;

  User copyWith({
    String? id,
    String? email,
    String? phoneNumber,
    Company? company,
    bool? eFacturaAuth,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      company: company ?? this.company,
      eFacturaAuth: eFacturaAuth ?? this.eFacturaAuth,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      company: json.containsKey('company')
          ? Company.fromJson(json['company'])
          : null,
      eFacturaAuth:
          json.containsKey('efactura_auth') ? json['efactura_auth'] : false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone_number': phoneNumber,
      'company': company?.toJson(),
    };
  }
}
