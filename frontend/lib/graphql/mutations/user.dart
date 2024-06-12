const String saveUser = r'''
mutation  createNewAccount($input: UserInput!){   
    createNewAccount(input:$input){
        email,
        phone_number
        company{
            name,
            vat,
            vat_number,
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
