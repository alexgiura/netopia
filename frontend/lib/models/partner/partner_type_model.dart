class PartnerType {
  String name;

  PartnerType({
    required this.name,
  });

  PartnerType.empty() : name = '';

  bool isEmpty() {
    return name.isEmpty;
  }

  factory PartnerType.fromJson(Map<String, dynamic> json) {
    return PartnerType(
      name: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': name,
    };
  }

  static PartnerType company = PartnerType(
    name: 'Persoana Juridica',
  );

  static PartnerType individual = PartnerType(
    name: 'Persoana Fizica',
  );

  static List<PartnerType> get partnerTypes => [company, individual];

  @override
  String toString() {
    return name;
  }
}
