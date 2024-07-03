import 'package:erp_frontend_v2/models/address/address_model.dart';
import 'package:erp_frontend_v2/models/partner/partner_type_model.dart';

class Partner {
  String? id;
  String? code;
  String name;
  PartnerType type;
  bool? vat;
  String? vatNumber;
  String? registrationNumber;
  String? individualNumber;
  bool isActive;
  Address? address;

  Partner(
      {this.id,
      this.code,
      this.address,
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
        type = PartnerType.empty(),
        vat = false,
        vatNumber = null,
        registrationNumber = null,
        individualNumber = null,
        isActive = true,
        address = Address.empty();

  bool isEmpty() {
    return id == null;
  }

  factory Partner.fromJson(Map<String, dynamic> json) {
    return Partner(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      type: PartnerType(name: json['type']),
      vat: json['vat'],
      vatNumber: json['vat_number'],
      registrationNumber: json['registration_number'],
      individualNumber: json['individual_number'],
      isActive: json['active'],
      address: json.containsKey('company_address')
          ? Address.fromJson(json['company_address'])
          : null,
    );
  }
}
