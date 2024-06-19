import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/utils/date.dart';
import 'package:erp_frontend_v2/widgets/buttons/primary_button.dart';
import 'package:erp_frontend_v2/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/partner_provider.dart';
import '../partners_autocomplete.dart';
import '../custom_date_picker.dart';

class FilterSectionLarge extends ConsumerStatefulWidget {
  final void Function(
    DateTime startDate,
    DateTime endDate,
    String series,
    String number,
    String partner,
  ) onChanged;

  final void Function() onPressed;

  const FilterSectionLarge({
    super.key,
    required this.onChanged,
    required this.onPressed,
  });

  @override
  ConsumerState<FilterSectionLarge> createState() => _FilterSectionLargeState();
}

class _FilterSectionLargeState extends ConsumerState<FilterSectionLarge> {
  DateTime startDate = DateTime.now().startOfDay;
  DateTime endDate = DateTime.now().startOfDay;
  String series = '';
  String number = '';
  String partner = '';

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      decoration: CustomStyle.customContainerDecoration(),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                  child: DatePickerWidget(
                labelText: 'Data inceput',
                onDateChanged: (DateTime? value) {
                  setState(() {
                    startDate = value!;
                    widget.onChanged(
                        startDate, endDate, series, number, partner);
                  });
                },
              )),
              SizedBox(
                width: width / 64,
              ),
              Expanded(
                  child: DatePickerWidget(
                labelText: 'Data sfarsit',
                onDateChanged: (DateTime? value) {
                  setState(() {
                    endDate = value!;
                    widget.onChanged(
                        startDate, endDate, series, number, partner);
                  });
                },
              )),
              SizedBox(
                width: width / 64,
              ),
              Spacer(),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: CustomTextField(
                  labelText: 'Serie',
                  hintText: 'Cauta dupa serie',
                  initialValue: series,
                  enabled: true,
                  onValueChanged: (String value) {
                    series = value;
                    widget.onChanged(
                        startDate, endDate, series, number, partner);
                  },
                ),
              ),
              SizedBox(
                width: width / 64,
              ),
              Expanded(
                child: CustomTextField(
                  labelText: 'Numar',
                  hintText: 'Cauta dupa numar',
                  initialValue: number,
                  enabled: true,
                  onValueChanged: (String value) {
                    number = value;
                    widget.onChanged(
                        startDate, endDate, series, number, partner);
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
                      labelText: 'Partner',
                      hintText: 'Partner',
                      onValueChanged: (value) {
                        partner = value;

                        widget.onChanged(
                            startDate, endDate, series, number, partner);
                      },
                      partnersList: partners,
                      initialValue:
                          partner, // Pass the partners list as a parameter
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
                  icon: const Icon(
                    Icons.search_outlined,
                    color: CustomColor.white,
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
                    series = '';
                    number = '';
                    partner = '';
                  });
                  widget.onChanged(startDate, endDate, series, number, partner);
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
