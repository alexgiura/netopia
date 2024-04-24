const String getCompany = r'''
query getCompany{
    getCompany{
        id,
        name,
        vat_number,
        registration_number,
        address,
        email,
        bank_name,
        bank_account
    }
}
''';
