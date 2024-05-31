import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/partner_provider.dart';
import '../partners_autocomplete.dart';

class FilterSectionLarge3 extends ConsumerStatefulWidget {
  final void Function(
    String code,
    String name,
    String type,
    String companyId,
  ) onChanged;

  final void Function() onPressed;

  const FilterSectionLarge3({
    super.key,
    required this.onChanged,
    required this.onPressed,
  });

  @override
  ConsumerState<FilterSectionLarge3> createState() =>
      _FilterSectionLarge3State();
}

class _FilterSectionLarge3State extends ConsumerState<FilterSectionLarge3> {
  String code = '';
  String name = '';
  String type = '';
  String companyId = '';

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
                  initialValue: '',
                  onValueChanged: (String value) {
                    setState(() {
                      code = value;
                      widget.onChanged(code, name, type, companyId);
                    });
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
                  initialValue: '',
                  enabled: true,
                  onValueChanged: (String value) {
                    setState(() {
                      name = value;
                      widget.onChanged(code, name, type, companyId);
                    });
                  },
                ),
              ),
              SizedBox(
                width: width / 64,
              ),
              Expanded(
                flex: 2,
                child: Consumer(
                  builder: (context, watch, _) {
                    final partners = ref.refresh(partnerProvider).value ?? [];

                    return PartnerSearchWidget(
                      labelText: 'Tip',
                      hintText: 'Tip',
                      onValueChanged: (value) {
                        setState(() {
                          type = value;
                          widget.onChanged(code, name, type, companyId);
                        });
                      },
                      partnersList:
                          partners, // Pass the partners list as a parameter
                    );
                  },
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
                  icon: const Icon(Icons.search_outlined),
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
                  // Handle button press
                },
                style: CustomStyle.tertiaryButton,
                child:
                     Text('Clear', style: CustomStyle.tertiaryButtonText),
              )
            ],
          )
        ],
      ),
    );
  }
}
