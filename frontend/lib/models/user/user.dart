import 'package:erp_frontend_v2/models/company/company_model.dart';

import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 1)
class User {
  User({
    required this.id,
    this.email,
    this.phoneNumber,
    this.company,
  });
  @HiveField(0)
  String id;

  @HiveField(1)
  String? email;

  @HiveField(2)
  String? phoneNumber;

  @HiveField(3)
  Company? company;

  User.empty()
      : id = '',
        email = '',
        phoneNumber = null,
        company = Company.empty();

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      company: json.containsKey('company')
          ? Company.fromJson(json['company'])
          : null,
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
