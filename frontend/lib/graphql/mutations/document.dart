const String saveDocument = r'''
mutation saveDocument($input: DocumentInput!) {
  saveDocument(input: $input){
    h_id,
    type{
            id,
            name_ro,
            name_en
        } 
    series,
    number,
    date,
    notes,
    deleted,
    efactura_status,
    partner{
        id,
        code,        
        type,        
        active,
        name,
        vat,
        vat_number,
        registration_number,
        individual_number 
    },
    document_items{
        d_id,
        item{           
            id,
            code,
            name,
            is_active,
            is_stock,
            um{
                id,
                name,
                code,
                is_active
             },
            vat{
                id,
                name,
                percent
            },
        }
      
      quantity,
      price,     
      amount_net,
      amount_vat,
      amount_gross,
      item_type_pn
    } 
  }
}
''';

const String deleteDocument = r'''
mutation deleteDocument($input: DeleteDocumentInput!) {
  deleteDocument(input: $input) 
}
''';
