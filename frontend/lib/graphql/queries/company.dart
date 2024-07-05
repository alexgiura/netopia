const String getCompany = r'''
query getCompany($taxId: String){
    getCompany(taxId: $taxId){    
        name,
        vat_number,
        vat,
        registration_number,
        company_address{
            address,
            locality,
            county_code
        }        
    }
}
''';

const String getCompanyByTaxId = r'''
query  getCompanyByTaxId($taxId: String!) {
   getCompanyByTaxId(taxId: $taxId){      
        name,    
        vat_number,
        vat,
        registration_number,
        company_address{
            address,
            locality,
            county_code
        }       
    }
}
''';
