import 'package:erp_frontend_v2/models/document/document_model.dart';
import 'package:erp_frontend_v2/models/recipe/recipe_model.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../graphql/graphql_client.dart';
import '../graphql/queries/recipe.dart' as queries;
import '../graphql/mutations/recipe.dart' as mutations;

class RecipeService {
  Future<List<Recipe>> getRecipes() async {
    final QueryOptions options = QueryOptions(
      document: gql(queries.getRecipes),
      fetchPolicy: FetchPolicy.noCache,
    );

    final QueryResult result = await graphQLClient.value.query(options);

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }
    final dynamic data = result.data!['getRecipes'];

    if (data != null && data is List<dynamic>) {
      final List<Recipe> recips =
          data.map((json) => Recipe.fromJson(json)).toList();
      return recips;
    } else {
      throw Exception('Invalid data');
    }
  }

  Future<String> saveRecipe({required Recipe recipe}) async {
    final List<Map<String, dynamic>> itemsList =
        recipe.documentItems!.map((item) {
      return {
        "item_id": item.id,
        "quantity": item.quantity,
        "item_type_pn": item.itemTypePn
      };
    }).toList();
    final QueryOptions options = QueryOptions(
      document: gql(mutations.saveRecipe),
      variables: <String, dynamic>{
        "input": {
          "id": recipe.id,
          "name": recipe.name,
          "is_active": recipe.isActive,
          "document_items": itemsList,
        }
      },
      fetchPolicy: FetchPolicy.noCache,
    );

    final QueryResult result = await graphQLClient.value.query(options);

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }
    final dynamic data = result.data!;

    if (data != null) {
      final String response = data['saveRecipe'];
      return response;
    } else {
      throw Exception('Invalid form data.');
    }
  }

  Future<Recipe> getRecipeById({
    required String recipeId,
  }) async {
    final QueryOptions options = QueryOptions(
      document: gql(queries.getRecipeById),
      variables: <String, dynamic>{"recipeId": int.parse(recipeId)},
      fetchPolicy: FetchPolicy.noCache,
    );

    final QueryResult result = await graphQLClient.value.query(options);

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final dynamic data = result.data!['getRecipeById'];
    if (data != null) {
      final Recipe recipe = Recipe.fromJson(data);

      return recipe;
    } else {
      throw Exception('Invalid documents data.');
    }
  }
}
