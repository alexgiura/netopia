import 'package:erp_frontend_v2/models/company/company_model.dart';

// class User {
//   String id;
//   String email;
//   String? phoneNumber;
//   Company? company;

//   User({
//     required this.id,
//     required this.email,
//     this.phoneNumber,
//     this.company,
//   });

//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       id: json['id'],
//       email: json['email'],
//       phoneNumber: json['phone_number'],
//       company: json.containsKey('company')
//           ? Company.fromJson(json['company'])
//           : null,
//     );
//   }
// }

import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 1)
class User {
  User({
    required this.id,
    required this.email,
    this.phoneNumber,
    this.company,
  });
  @HiveField(0)
  String id;

  @HiveField(1)
  String email;

  @HiveField(2)
  String? phoneNumber;

  @HiveField(3)
  Company? company;

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
}
