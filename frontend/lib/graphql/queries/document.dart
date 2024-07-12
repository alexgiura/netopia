const String getDocuments = r'''
query getDocuments($input: GetDocumentsInput!){
    getDocuments(input:$input){
        h_id, 
        type{
            id,
            name_en,
            name_ro
        }         
        series,
        number,
        date,
        due_date,
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
        }      
    }
}
''';

const String getDocumentById = r'''
query  getDocumentById($documentId: String!) {
   getDocumentById(documentId: $documentId){
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

const String getDocumentTransactions = r'''
query getDocumentTransactions{
    getDocumentTransactions{
        id,
        name,
        document_type_source_id,
        document_type_destination_id
    }
}
''';

const String getGenerateAvailableItems = r'''
query  getGenerateAvailableItems($input: GetGenerateAvailableItemsInput!) {
   getGenerateAvailableItems(input:$input){
    h_id,  
    series,
    number,
    date,
    document_item{
        d_id,
        item{
          id,
          code,
          name,
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
        quantity,      
    }  
  }
}
''';
