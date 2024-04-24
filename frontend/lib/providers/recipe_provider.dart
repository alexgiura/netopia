import 'package:erp_frontend_v2/models/recipe/recipe_model.dart';
import 'package:erp_frontend_v2/services/recipe.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recipeProvider = FutureProvider<List<Recipe>>((ref) async {
  final recipes = await RecipeService().getRecipes();
  return recipes;
});
