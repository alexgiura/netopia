const String getUser = r'''
query getUser($userId: String!) {
    getUser(userId:$userId){    
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
