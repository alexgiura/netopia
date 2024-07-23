import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/models/document/document_model.dart';
import 'package:erp_frontend_v2/models/recipe/recipe_model.dart';
import 'package:erp_frontend_v2/pages/document/document_add_item/add_item_popup.dart';
import 'package:erp_frontend_v2/pages/production/widgets/recipe_details_data_table.dart';
import 'package:erp_frontend_v2/providers/recipe_provider.dart';
import 'package:erp_frontend_v2/services/recipe.dart';
import 'package:erp_frontend_v2/widgets/buttons/primary_button.dart';
import 'package:erp_frontend_v2/widgets/custom_header_widget.dart';
import 'package:erp_frontend_v2/widgets/custom_tab_bar.dart';
import 'package:erp_frontend_v2/widgets/custom_text_field_1.dart';
import 'package:erp_frontend_v2/widgets/custom_toggle.dart';
import 'package:erp_frontend_v2/widgets/dialog_widgets/custom_toast.dart';
import 'package:erp_frontend_v2/widgets/dialog_widgets/warning_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../../../constants/style.dart';
import '../../../utils/responsiveness.dart';

class RecipeDetailsPage extends ConsumerStatefulWidget {
  final String hId;

  const RecipeDetailsPage({
    super.key,
    required this.hId,
  });

  @override
  ConsumerState<RecipeDetailsPage> createState() => _DocumentDetailsPageState();
}

class _DocumentDetailsPageState extends ConsumerState<RecipeDetailsPage>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _documentDetailsFormKey = GlobalKey<FormState>();

  bool _isLoading = false;
  Recipe _recipe = Recipe.empty();
  int tabIndex = 0;
  String? nameError;

  @override
  void initState() {
    super.initState();

    if (widget.hId != '0') {
      _fetchRecipe(widget.hId);
    }
  }

  Future<void> _fetchRecipe(recipeId) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final recipeService = RecipeService();

      final recipe = await recipeService.getRecipeById(recipeId: widget.hId);

      setState(() {
        _recipe = recipe;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: ResponsiveWidget.isSmallScreen(context) ? 0 : 24,
        right: ResponsiveWidget.isSmallScreen(context) ? 0 : 24,
        top: ResponsiveWidget.isSmallScreen(context) ? 24 : 32,
        bottom: ResponsiveWidget.isSmallScreen(context) ? 0 : 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTitle(),
          const SizedBox(height: 16),
          _isLoading == true
              ? const Expanded(
                  child: Center(child: CircularProgressIndicator()))
              : Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      Gap(32),
                      _buildDetails(),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Row(
      children: [
        CustomHeader(
          title:
              ('${'recipes'.tr(context)} / ${widget.hId == '0' ? 'add'.tr(context) : 'edit'.tr(context)}'),
          hasBackIcon: true,
        ),
        const Spacer(),
        PrimaryButton(
          text: 'save'.tr(context),
          icon: Icons.save,
          asyncOnPressed: () async {
            if (_documentDetailsFormKey.currentState!.validate()) {
              try {
                await RecipeService().saveRecipe(recipe: _recipe);
                ref.read(recipeProvider.notifier).refreshRecipes();

                showToast('success_save_recipe'.tr(context), ToastType.success);
                Navigator.of(context).pop();
              } catch (error) {
                if (error.toString().contains('Recipe already exists')) {
                  nameError = 'recipe_already_registered_error'.tr(context);
                } else {
                  showToast('error_try_again'.tr(context), ToastType.error);
                }
              }
            }
          },
        )
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: CustomStyle.customContainerDecoration(border: true),
      child: Form(
        key: _documentDetailsFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'recipe_details'.tr(context),
              style: CustomStyle.medium20(),
            ),
            const Gap(24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: CustomTextField1(
                      labelText: 'name'.tr(context),
                      hintText: 'recipe_name_hint'.tr(context),
                      initialValue: _recipe.name,
                      onValueChanged: (String value) {
                        _recipe.name = value;
                        nameError = null;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'error_required_field'.tr(context);
                        }
                        if (nameError != null) {
                          return nameError;
                        }
                        return null;
                      },
                      required: true,
                    ),
                  ),
                ),
                const Expanded(flex: 2, child: SizedBox())
              ],
            ),
            const Gap(8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomToggle(
                  title: 'active'.tr(context),
                  subtitle: 'recipe_activ_description'.tr(context),
                  initialValue: _recipe.isActive,
                  onChanged: (value) {
                    _recipe.isActive = value;
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDetails() {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        decoration: CustomStyle.customContainerDecoration(border: true),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'included_products'.tr(context),
                      style: CustomStyle.medium20(),
                    ),
                    Text(
                      'included_products_description'.tr(context),
                      style:
                          CustomStyle.regular14(color: CustomColor.greenGray),
                    ),
                  ],
                ),
                const Spacer(),
              ],
            ),
            const Gap(24),
            Flexible(
              child: CustomTabBar(
                  tabs: [
                    Text('final_product'.tr(context)),
                    Text('raw_material'.tr(context)),
                  ],
                  tabViews: [
                    RecipeItemsDataTable(
                      data: _recipe.documentItems
                          .where((item) => item.itemTypePn == 'finalProduct')
                          .toList(),
                      onUpdate: (data) {
                        setState(() {
                          _recipe.documentItems.removeWhere(
                              (item) => item.itemTypePn == 'finalProduct');
                          _recipe.documentItems.addAll(data);
                        });
                      },
                    ),
                    RecipeItemsDataTable(
                      data: _recipe.documentItems
                          .where((item) => item.itemTypePn == 'rawMaterial')
                          .toList(),
                      onUpdate: (data) {
                        setState(() {
                          _recipe.documentItems.removeWhere(
                              (item) => item.itemTypePn == 'rawMaterial');
                          _recipe.documentItems.addAll(data);
                        });
                      },
                    )
                  ],
                  onChanged: (value) {
                    tabIndex = value;
                  },
                  sufixButton: PrimaryButton(
                    text: 'add'.tr(context),
                    icon: Icons.add,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AddItemPopup(
                            itemTypePn:
                                tabIndex == 0 ? 'finalProduct' : 'rawMaterial',
                            callback: (documentItems) {
                              setState(() {
                                _recipe.documentItems.addAll(documentItems);
                              });
                            },
                          );
                        },
                      );
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
