const String saveDepartment = r'''
mutation saveDepartment($input: DepartmentInput!){   
    saveDepartment(input:$input){
        id,
        name,
        flags,
        
    }
}
''';
