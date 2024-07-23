import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/models/recipe/recipe_model.dart';
import 'package:erp_frontend_v2/providers/item_provider.dart';
import 'package:erp_frontend_v2/providers/recipe_provider.dart';
import 'package:erp_frontend_v2/routing/routes.dart';
import 'package:erp_frontend_v2/widgets/buttons/edit_button.dart';
import 'package:erp_frontend_v2/widgets/custom_activ_status.dart';
import 'package:erp_frontend_v2/widgets/custom_data_table.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/style.dart';

class RecipesDataTable extends ConsumerStatefulWidget {
  const RecipesDataTable({
    super.key,
  });

  @override
  ConsumerState<RecipesDataTable> createState() => _RecipesDataTableState();
}

class _RecipesDataTableState extends ConsumerState<RecipesDataTable> {
  String selectedHid = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final recipeState = ref.watch(recipeProvider);

    final List<DataColumn2> _columns = [
      DataColumn2(
        label: Text(
          'name'.tr(context),
          style: CustomStyle.semibold16(color: CustomColor.greenGray),
        ),
        size: ColumnSize.L,
      ),
      DataColumn2(
          label: Container(
              alignment: Alignment.center,
              child: Text(
                'active'.tr(context),
                style: CustomStyle.semibold16(color: CustomColor.greenGray),
              )),
          size: ColumnSize.S),
      DataColumn2(
          label: Container(
              alignment: Alignment.center,
              child: Text(
                'details'.tr(context),
                style: CustomStyle.semibold16(color: CustomColor.greenGray),
              )),
          fixedWidth: 100),
    ];

    return recipeState.when(
      skipLoadingOnReload: true,
      skipLoadingOnRefresh: true,
      data: (recipeList) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: CustomStyle.customContainerDecoration(),
          child: CustomDataTable(
            columns: _columns,
            rows: getRows(recipeList),
          ),
        );
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      error: (error, stackTrace) {
        return Text("Error: $error");
      },
    );
  }

  List<DataRow2> getRows(List<Recipe> recipeList) => recipeList
      .map((Recipe recipe) => DataRow2(
            cells: [
              DataCell(
                Text(
                  recipe.name,
                  style: CustomStyle.semibold14(),
                ),
              ),
              DataCell(Container(
                alignment: Alignment.center,
                child: CustomActiveStatus(
                  isActive: recipe.isActive,
                ),
              )),
              DataCell(Container(
                alignment: Alignment.center,
                child: CustomEditButton(
                  onTap: () {
                    context.goNamed(
                      productionRecipeDetailsPageName,
                      pathParameters: {'id1': recipe.id.toString()},
                    );
                  },
                ),
              )),
            ],
          ))
      .toList();
}
