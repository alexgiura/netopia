const String getPartners = r'''
query getPartners{
    getPartners{
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
