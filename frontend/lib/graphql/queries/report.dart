const String getRevenueChart = r'''
query  getRevenueChart{
    getRevenueChart{
        x,
        y,
       second_y,
    }
}
''';

const String getProductionNoteReport = r'''
query   getProductionNoteReport($input: ReportInput!) {
    getProductionNoteReport(input:$input){
        date,
        partner_name,
        item_name,
        item_quantity,
        raw_material
    }       
}
''';

const String getItemStockReport = r'''
query   getStockReport($input: StockReportInput!) {
    getStockReport(input:$input){             
        item_code,
        item_name,       
        item_um,
        item_quantity
    }       
}
''';

const String getTransactionAvailableItems = r'''
query  getTransactionAvailableItems($input: TransactionAvailableItemsInput!) {
   getTransactionAvailableItems(input:$input){
    h_id,  
    series,
    number,
    date,
    document_item{
        d_id,
      item_id,
      item_code,
      item_name,
      quantity,
      um{
          id,
          name
      }
      vat{
          id,
          name,
          percent
      }
    }  
   }
}
''';
