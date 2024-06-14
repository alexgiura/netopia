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

  Address copyWith({
    String? address,
    String? locality,
    String? countyCode,
  }) {
    return Address(
      address: address ?? this.address,
      locality: locality ?? this.locality,
      countyCode: countyCode ?? this.countyCode,
    );
  }

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
