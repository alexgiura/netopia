import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/partner_provider.dart';
import '../partners_autocomplete.dart';

class FilterSectionLarge2NoCard extends ConsumerStatefulWidget {
  final void Function(
    String code,
    String name,
    String type,
  ) onChanged;

  final void Function() onPressed;

  const FilterSectionLarge2NoCard({
    super.key,
    required this.onChanged,
    required this.onPressed,
  });

  @override
  ConsumerState<FilterSectionLarge2NoCard> createState() =>
      _FilterSectionLarge2NoCardState();
}

class _FilterSectionLarge2NoCardState
    extends ConsumerState<FilterSectionLarge2NoCard> {
  String code = '';
  String name = '';
  String type = '';

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      // decoration: CustomStyle.customContainerDecoration,
      // padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  labelText: 'Cod',
                  hintText: 'Cauta dupa cod',
                  initialValue: '',
                  enabled: true,
                  onValueChanged: (String value) {
                    setState(() {
                      code = value;
                      widget.onChanged(code, name, type);
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
                      widget.onChanged(code, name, type);
                    });
                  },
                ),
              ),
              SizedBox(
                width: width / 64,
              ),
              Expanded(
                child: Consumer(
                  builder: (context, watch, _) {
                    final partners = ref.refresh(partnerProvider).value ?? [];

                    return PartnerSearchWidget(
                      labelText: 'Tip',
                      hintText: 'Tip',
                      onValueChanged: (value) {
                        setState(() {
                          type = value;
                          widget.onChanged(code, name, type);
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
                    const Text('Clear', style: CustomStyle.tertiaryButtonText),
              )
            ],
          )
        ],
      ),
    );
  }
}
