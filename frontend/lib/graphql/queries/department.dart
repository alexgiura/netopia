const String getDepartments = r'''
query GetDepartments{
    getDepartments{
        id,
        name,
        flags,
        parents{
            id,
            name,
            flags
        }
    }
}
''';
