class PartnerType {
  final String name;

  const PartnerType(this.name);

  static const PartnerType company = PartnerType('Persoana Juridica');
  static const PartnerType individual = PartnerType('Persoana Fizica');
  static List<PartnerType> get partnerTypes => [company, individual];
  @override
  String toString() {
    return name;
  }
}
