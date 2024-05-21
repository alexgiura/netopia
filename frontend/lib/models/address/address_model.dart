class Address {
  String? address;
  String? locality;
  String? countyCode;

  Address({
    this.address,
    this.locality,
    this.countyCode,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      address: json['address'],
      locality: json['locality'],
      countyCode: json['county_code'],
    );
  }
}
