import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/models/recipe/recipe_model.dart';
import 'package:erp_frontend_v2/pages/production/widgets/production_recipes_data_table.dart';
import 'package:erp_frontend_v2/routing/routes.dart';
import 'package:erp_frontend_v2/services/recipe.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../helpers/responsiveness.dart';

class ProductionRecipesPage extends StatefulWidget {
  const ProductionRecipesPage({super.key});

  @override
  State<ProductionRecipesPage> createState() => _ProductionRecipesPageState();
}

class _ProductionRecipesPageState extends State<ProductionRecipesPage> {
  late bool _isLoading = false;
  late List<Recipe> _recipeList = [];

  @override
  void initState() {
    super.initState();
    _isLoading = true;

    _fetchRecipes();
  }

  Future<void> _fetchRecipes() async {
    try {
      final recipeService = RecipeService();
      final recipes = await recipeService.getRecipes();

      setState(() {
        _recipeList = recipes;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomColor.lightest,
      padding: EdgeInsets.only(
        left: ResponsiveWidget.isSmallScreen(context) ? 0 : 24,
        right: ResponsiveWidget.isSmallScreen(context) ? 0 : 24,
        top: ResponsiveWidget.isSmallScreen(context) ? 56 : 32,
        bottom: ResponsiveWidget.isSmallScreen(context) ? 0 : 24,
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'Retete',
                style: CustomStyle.titleText,
              ),

              const Spacer(),
              //SizedBox.expand(),
              SizedBox(
                height: 35,
                child: ElevatedButton.icon(
                  style: CustomStyle.activeButton,
                  onPressed: () async {
                    context.goNamed(
                      productionRecipeDetailsPageName,
                      pathParameters: {'id1': '0'},
                      extra: () {
                        _fetchRecipes();
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.add,
                    color: CustomColor.white,
                  ),
                  label: const Text(
                    'Adaugă',
                    style: CustomStyle.primaryButtonText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
              child: ProductionRecipesDataTable(
                  data: _recipeList, refreshCallback: () => _fetchRecipes()))
        ],
      ),
    );
  }
}
