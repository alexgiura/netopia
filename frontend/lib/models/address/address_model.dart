class Address {
  String? address;
  String? locality;
  String? countyCode;

  Address({
    this.address,
    this.locality,
    this.countyCode,
  });

  Address.empty()
      : address = null,
        locality = null,
        countyCode = null;

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      address: json['address'],
      locality: json['locality'],
      countyCode: json['county_code'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'locality': locality,
      'county_code': countyCode,
    };
  }
}
