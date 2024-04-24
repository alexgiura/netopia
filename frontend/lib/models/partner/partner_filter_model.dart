class PartnerFilter {
  String? code;
  String? name;
  String? type;
  String? taxId;

  PartnerFilter({
    required this.code,
    required this.name,
    required this.type,
    required this.taxId,
  });

  PartnerFilter.empty()
      : code = null,
        name = null,
        type = null,
        taxId = null;
}
