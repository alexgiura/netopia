const String getCompany = r'''
query getCompany{
    getCompany{
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
