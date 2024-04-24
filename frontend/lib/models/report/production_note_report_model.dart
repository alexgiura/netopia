class ProductionNoteReport {
  String date;
  String partnerName;
  String itemName;
  double itemQuantity;
  List<double> rawMaterial;

  ProductionNoteReport({
    required this.date,
    required this.partnerName,
    required this.itemName,
    required this.itemQuantity,
    required this.rawMaterial,
  });

  ProductionNoteReport.empty()
      : date = '',
        partnerName = '',
        itemName = '',
        itemQuantity = 0.00,
        rawMaterial = List.empty();

  factory ProductionNoteReport.fromJson(Map<String, dynamic> json) {
    var rawMaterialFromJson = json['raw_material'] as List<dynamic>;

    List<double> rawMaterialList = rawMaterialFromJson
        .map((item) => double.parse(item.toString()))
        .toList();
    return ProductionNoteReport(
      date: json['date'],
      partnerName: json['partner_name'],
      itemName: json['item_name'],
      itemQuantity: json['item_quantity'],
      rawMaterial: rawMaterialList,
    );
  }
}
