import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/models/item/item_category_model.dart';
import 'package:erp_frontend_v2/providers/item_provider.dart';
import 'package:erp_frontend_v2/widgets/custom_dropdown.dart';
import 'package:erp_frontend_v2/widgets/custom_search_dropdown.dart';
import 'package:erp_frontend_v2/widgets/custom_text_field.dart';
import 'package:erp_frontend_v2/widgets/not_used_widgets/item_category_autocomplete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/partner_provider.dart';
import '../partners_autocomplete.dart';

class FilterSectionLarge2 extends ConsumerStatefulWidget {
  final void Function(
    String code,
    String name,
    String type,
  ) onChanged;

  final void Function() onPressed;

  const FilterSectionLarge2({
    super.key,
    required this.onChanged,
    required this.onPressed,
  });

  @override
  ConsumerState<FilterSectionLarge2> createState() =>
      _FilterSectionLarge2State();
}

class _FilterSectionLarge2State extends ConsumerState<FilterSectionLarge2> {
  String code = '';
  String name = '';
  ItemCategory type = ItemCategory.empty();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      decoration: CustomStyle.customContainerDecoration,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  labelText: 'Cod',
                  hintText: 'Cauta dupa cod',
                  initialValue: code,
                  enabled: true,
                  onValueChanged: (String value) {
                    code = value;
                    widget.onChanged(code, name, type.name);
                  },
                ),
              ),
              SizedBox(
                width: width / 64,
              ),
              Expanded(
                child: CustomTextField(
                  labelText: 'Nume',
                  hintText: 'Cauta dupa nume',
                  initialValue: name,
                  enabled: true,
                  onValueChanged: (String value) {
                    name = value;
                    widget.onChanged(code, name, type.name);
                  },
                ),
              ),
              SizedBox(
                width: width / 64,
              ),
              Expanded(
                flex: 2,
                child: SearchDropDown(
                  labelText: 'Categorie',
                  hintText: 'Cauta dupa categorie',
                  onValueChanged: (value) {
                    setState(
                      () {
                        type = (value as dynamic);
                        widget.onChanged(code, name, type.name);
                      },
                    );
                  },
                  initialValue: type,
                  provider: itemCategoryProvider,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          Row(
            children: [
              SizedBox(
                height: 35,
                child: ElevatedButton.icon(
                  style: CustomStyle.activeButton,
                  onPressed: () {
                    widget.onPressed();
                  },
                  icon: const Icon(
                    Icons.search_outlined,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Cauta',
                    style: CustomStyle.primaryButtonText,
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    code = '';
                    name = '';
                    type = ItemCategory.empty();
                  });
                  widget.onChanged(code, name, type.name);
                  widget.onPressed();
                },
                style: CustomStyle.tertiaryButton,
                child: Text('Clear', style: CustomStyle.tertiaryButtonText),
              )
            ],
          )
        ],
      ),
    );
  }
}
