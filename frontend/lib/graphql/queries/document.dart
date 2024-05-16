const String getDocuments = r'''
query getDocuments($input: GetDocumentsInput!){
    getDocuments(input:$input){
        h_id,          
        series,
        number,
        date,
        partner,
        is_deleted,
        status
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
    person_name,
    document_items{
      item_id,
      item_code,
      item_name,
      quantity,
      um{
          id,
          name
      },
      price,
      vat{
          id,
          name,
          percent
      },
      amount_net,
      amount_vat,
      amount_gross
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
