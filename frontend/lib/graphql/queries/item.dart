const String getItems = r'''
query getItems($input: GetItemsInput!){   
    getItems(input:$input){
        id,
        code,
        name,
        is_active,
        is_stock,
        um{
            id,
            name
        },
        vat{
            id,
            name,
            percent
        },
        category{
            id,
            name,
            is_active,
            generate_pn
            
        }
        
    }
}
''';

const String getUmList = r'''
query getUmList{
    getUmList{
        id,
        name,
        code,
        is_active
    }
}
''';

const String getVatList = r'''
query GetVatList{
    getVatList{
        id,
        name,
        percent,
        is_active
    }
}
''';

const String getItemCategoryList = r'''
query GetItemCategoryList{
     getItemCategoryList{
        id,
        name,
        is_active,
        generate_pn
    }
}
''';
