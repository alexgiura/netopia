const String getRecipes = r'''
query getRecipes{
    getRecipes{
        id,
        name,
        is_active,
        document_items{
            item_id,
            item_code,
            item_name,
            quantity,
            um{
                 id,
                 name
            },
            item_type_pn
            
        }
    }
}
''';

const String getRecipeById = r'''
query  getRecipeById($recipeId: Int!) {
   getRecipeById(recipeId: $recipeId){
    id,
    name,
    is_active,
    document_items{
        item_id,
        item_code,
        item_name,
        quantity,
        um{
            id,
            name
        },
        item_type_pn
    } 
   }
}
''';
