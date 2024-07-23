const String saveRecipe = r'''
mutation saveRecipe($input: SaveRecipeInput!){   
    saveRecipe(input:$input){
         id,
        name,
        is_active,
        document_items{
            d_id
            item{           
                id,
                code,
                name,
                is_active,
                is_stock,
                um{
                    id,
                    name,
                    code,
                    is_active
                },
                vat{
                    id,
                    name,
                    percent
                },
            }     
            quantity,
            item_type_pn
        } 
    }
        
}
''';
