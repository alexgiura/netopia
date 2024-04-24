const String getPartners = r'''
query ($input: GetPartnersInput!){
    getPartners(input:$input){
        id,
        code,
        name,
        type,
        tax_id,
        company_number,
        personal_id,
        is_active
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
