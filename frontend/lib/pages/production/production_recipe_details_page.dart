import 'package:erp_frontend_v2/constants/constants.dart';
import 'package:erp_frontend_v2/models/recipe/recipe_model.dart';
import 'package:erp_frontend_v2/pages/production/widgets/production_recipe_details_data_table.dart';
import 'package:erp_frontend_v2/services/recipe.dart';
import 'package:erp_frontend_v2/widgets/custom_checkbox.dart';
import 'package:erp_frontend_v2/widgets/custom_header_widget.dart';
import 'package:erp_frontend_v2/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../constants/style.dart';
import '../../utils/responsiveness.dart';
import '../../../utils/customSnackBar.dart';

class ProductionRecipeDetailsPage extends ConsumerStatefulWidget {
  final String? id;
  final void Function()? refreshCallback;

  const ProductionRecipeDetailsPage(
      {super.key, required this.id, this.refreshCallback});

  @override
  ConsumerState<ProductionRecipeDetailsPage> createState() =>
      _ProductionRecipeDetailsPageState();
}

class _ProductionRecipeDetailsPageState
    extends ConsumerState<ProductionRecipeDetailsPage> {
//
  final TextEditingController textController1 = TextEditingController();
  final GlobalKey<CustomTextFieldState> formKey1 =
      GlobalKey<CustomTextFieldState>();

//

  late bool _isLoading = false;
  Recipe _recipe = Recipe.empty();

  @override
  void initState() {
    super.initState();

    if (widget.id != '0' && (int.tryParse(widget.id!) != null)) {
      _isLoading = true;
      _fetchRecipe();
    }
  }

  Future<void> _fetchRecipe() async {
    try {
      final recipeService = RecipeService();

      final recipe = await recipeService.getRecipeById(recipeId: widget.id!);
      print(recipe);

      setState(() {
        _recipe = recipe;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveRecipe(Recipe recipe) async {
    // setState(() {
    //   _isLoading = true;
    // });

    try {
      final recipeService = RecipeService();
      final String result = await recipeService.saveRecipe(recipe: _recipe);

      // setState(() {
      //   _isLoading = false;
      // });

      if (result.isNotEmpty) {
        if (context.mounted) {
          showSnackBar(context, 'Reteta a fost salvata!', SnackBarType.success);
          if (widget.refreshCallback != null) {
            widget.refreshCallback!();
          }

          Navigator.of(context).pop();
        }
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          behavior: SnackBarBehavior.floating, // Move SnackBar to top
          backgroundColor: Colors.red, // Change background color
        ),
      );
      setState(() {
        _isLoading = false;
        //validateOnSave = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      color: CustomColor.lightest,
      padding: EdgeInsets.only(
        left: ResponsiveWidget.isSmallScreen(context) ? 0 : 24,
        right: ResponsiveWidget.isSmallScreen(context) ? 0 : 24,
        top: ResponsiveWidget.isSmallScreen(context) ? 56 : 32,
        bottom: ResponsiveWidget.isSmallScreen(context) ? 0 : 24,
      ),
      child: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CustomHeader(
                      title: 'Detalii Reteta',
                      hasBackIcon: true,
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 35,
                      child: ElevatedButton.icon(
                        style: CustomStyle.activeButton,
                        onPressed: () {
                          if (formKey1.currentState!.valid()) {
                            _saveRecipe(_recipe);
                          }
                        },
                        icon: const Icon(
                          Icons.save,
                          color: CustomColor.white,
                        ),
                        label: const Text(
                          'Salveaza',
                          style: CustomStyle.primaryButtonText,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: CustomTextField(
                                    key: formKey1,
                                    labelText: "Denumire (obligatoriu)",
                                    hintText: "Denumire reteta",
                                    errorText: "Camp Obligatoriu",
                                    initialValue: _recipe.name,
                                    onValueChanged: (String value) {
                                      setState(() {
                                        _recipe.name = value;
                                      });
                                    }),
                              ),
                              SizedBox(
                                width: width / 64,
                              ),
                            ],
                          ),
                        ),
                        // SizedBox(
                        //   width: width / 64,
                        // ),

                        Spacer(
                          flex: 2,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    CustomCheckbox(
                        value: _recipe.isActive,
                        labelText: "Activ",
                        onChanged: (value) {
                          setState(() {
                            _recipe.isActive = value;
                          });
                        }),
                  ],
                ),
                const SizedBox(height: 16),
                RecipeDetailsDataTable(
                  itemType: AppConstants.finalProduct,
                  title: 'Produs Finit',
                  data: _recipe.documentItems,
                  onUpdate: (updatedItems) {
                    _recipe.documentItems = updatedItems;
                  },
                ),
                const SizedBox(height: 8),
                RecipeDetailsDataTable(
                  itemType: AppConstants.rawMaterial,
                  title: 'Materie Prima',
                  data: _recipe.documentItems,
                  onUpdate: (updatedItems) {
                    _recipe.documentItems = updatedItems;
                  },
                ),
              ],
            ),
    );
  }
}
