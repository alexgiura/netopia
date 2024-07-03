import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/models/partner/partner_model.dart';
import 'package:erp_frontend_v2/utils/date.dart';
import 'package:erp_frontend_v2/widgets/not_used_widgets/custom_search_dropdown.dart';
import 'package:erp_frontend_v2/widgets/custom_search_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/partner_provider.dart';
import '../custom_date_picker.dart';

class FilterSectionLargeReport extends ConsumerStatefulWidget {
  final void Function(
    DateTime startDate,
    DateTime endDate,
    String partner,
  ) onChanged;

  final void Function() onPressed;

  const FilterSectionLargeReport({
    super.key,
    required this.onChanged,
    required this.onPressed,
  });

  @override
  ConsumerState<FilterSectionLargeReport> createState() =>
      _FilterSectionLargeReportState();
}

class _FilterSectionLargeReportState
    extends ConsumerState<FilterSectionLargeReport> {
  DateTime startDate = DateTime.now().startOfDay;
  DateTime endDate = DateTime.now().startOfDay;
  Partner partner = Partner.empty();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      //color: Colors.transparent,
      decoration: CustomStyle.customContainerDecoration(),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: DatePickerWidget(
                initialValue: startDate,
                labelText: 'Data inceput',
                onDateChanged: (DateTime? value) {
                  setState(() {
                    startDate = value!;
                    widget.onChanged(startDate, endDate, partner.id.toString());
                  });
                },
              )),
              SizedBox(
                width: width / 64,
              ),
              Expanded(
                  child: DatePickerWidget(
                initialValue: endDate,
                labelText: 'Data sfarsit',
                onDateChanged: (DateTime? value) {
                  setState(() {
                    endDate = value!;
                    widget.onChanged(startDate, endDate, partner.id.toString());
                  });
                },
              )),
              SizedBox(
                width: width / 64,
              ),
              Expanded(
                flex: 2,
                child: SearchDropDown(
                  labelText: 'Partener',
                  onValueChanged: (value) {
                    setState(
                      () {
                        partner = (value as dynamic);
                        widget.onChanged(
                            startDate, endDate, partner.id.toString());
                      },
                    );
                  },
                  provider: partnerProvider,
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
                    'Genereaza',
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
                    partner = Partner.empty();
                  });
                  widget.onChanged(startDate, endDate, partner.id.toString());
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
