class ItemStockReport {
  String? itemCode;
  String itemName;
  String? itemUm;
  double itemQuantity;
  double? total;

  ItemStockReport({
    this.itemCode,
    required this.itemName,
    this.itemUm,
    required this.itemQuantity,
    this.total = 0.00,
  });

  ItemStockReport.empty()
      : itemCode = null,
        itemName = '',
        itemUm = null,
        itemQuantity = 0.00,
        total = 0.00;

  factory ItemStockReport.fromJson(Map<String, dynamic> json) {
    return ItemStockReport(
      itemCode: json['item_code'],
      itemName: json['item_name'],
      itemUm: json['item_um'],
      itemQuantity: json['item_quantity'],
      total: json['total'],
    );
  }
}
