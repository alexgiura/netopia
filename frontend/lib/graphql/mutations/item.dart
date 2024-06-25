const String saveItem = r'''
mutation saveItem($input: ItemInput!){   
    saveItem(input:$input)
}
''';

const String saveItemCategory = r'''
mutation saveItemCategory($input: ItemCategoryInput!){   
    saveItemCategory(input:$input){
        id,
        name,
        is_active,
        generate_pn    
    }
}
''';

const String saveItemUnit = r'''
mutation saveUm($input: UmInput!){   
    saveUm(input:$input){
        id,
        name,
        code,
        is_active
    }
}
''';
