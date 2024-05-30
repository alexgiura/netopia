const String getUser = r'''
query getUser{
    getUser{    
        id,
        email,
        phone_number,
        company{
            id,
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
}
''';
