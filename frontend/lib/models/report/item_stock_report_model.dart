class ItemStockReport {
  String? itemCode;
  String itemName;
  String? itemUm;
  double itemQuantity;

  ItemStockReport({
    this.itemCode,
    required this.itemName,
    this.itemUm,
    required this.itemQuantity,
  });

  ItemStockReport.empty()
      : itemCode = null,
        itemName = '',
        itemUm = null,
        itemQuantity = 0.00;

  factory ItemStockReport.fromJson(Map<String, dynamic> json) {
    return ItemStockReport(
      itemCode: json['item_code'],
      itemName: json['item_name'],
      itemUm: json['item_um'],
      itemQuantity: json['item_quantity'],
    );
  }
}
