import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/models/recipe/recipe_model.dart';
import 'package:erp_frontend_v2/services/recipe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecipeProvider extends StateNotifier<AsyncValue<List<Recipe>>> {
  RecipeProvider() : super(const AsyncValue.loading()) {
    fetchRecipes();
  }

  Future<void> fetchRecipes() async {
    try {
      final recipeList = await RecipeService().getRecipes();
      state = AsyncValue.data(recipeList);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  void refreshRecipes() {
    fetchRecipes();
  }
}

final recipeProvider =
    StateNotifierProvider<RecipeProvider, AsyncValue<List<Recipe>>>((ref) {
  return RecipeProvider();
});
