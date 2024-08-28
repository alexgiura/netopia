const String getPartners = r'''
query getPartners($partnerId: String){
    getPartners(partnerId: $partnerId){
        id,
        code,
        type,
        active,
        name,
        vat,
        vat_number,
        registration_number,
        address{
            address,
            locality,
            county_code
        },
        bank_account{
            bank,
            iban
        }
    }
}
''';

const String getPartnerByTaxId = r'''
query  getPartnerByTaxId($taxId: String!) {
   getPartnerByTaxId(taxId: $taxId){
        id,
        code,
        name,
        type,
        tax_id,
        company_number,
        address,
        personal_id,
        is_active
    }
}
''';
