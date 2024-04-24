import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/models/partner/partner_type_model.dart';
import 'package:erp_frontend_v2/providers/partner_provider.dart';
import 'package:erp_frontend_v2/widgets/custom_checkbox.dart';
import 'package:erp_frontend_v2/widgets/custom_dropdown.dart';
import 'package:erp_frontend_v2/widgets/custom_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/partner/partner_model.dart';
import '../../utils/customSnackBar.dart';
import '../../widgets/custom_text_field.dart';
import '../../services/partner.dart';

class PartnerDetailsPopup extends ConsumerStatefulWidget {
  const PartnerDetailsPopup({super.key, required this.partner});
  final Partner? partner;
  // final void Function(Partner) onSave;
  @override
  ConsumerState<PartnerDetailsPopup> createState() =>
      _PartnerDetailsPopupState();
}

class _PartnerDetailsPopupState extends ConsumerState<PartnerDetailsPopup>
    with SingleTickerProviderStateMixin {
  // SlidingSegmented
  String _currentSelection = 'company';

  // FormKey for validation
  final GlobalKey<CustomTextFieldState> nameFormKey =
      GlobalKey<CustomTextFieldState>();
  final GlobalKey<CustomTextFieldState> taxIdFormKey =
      GlobalKey<CustomTextFieldState>();

  // Tab
  late TabController _tabController;

  // Partner
  late Partner _partner;

  @override
  void initState() {
    super.initState();

    _partner = widget.partner ?? Partner.empty();
    if (_partner.isEmpty()) {
      _partner.type = PartnerType.company.name!;
    }

    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _savePartner(Partner partner) async {
    try {
      final personService = PartnerService();
      final String result = await personService.savePartner(partner: partner);

      if (result == 'success') {
        // Refresh partnerProvider
        ref.read(partnerProvider.notifier).refreshPartners();

        if (context.mounted) {
          showSnackBar(context, 'Partner saved successfully!',
              const TextStyle(fontSize: 16));
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: CustomColor.white,
      scrollable: true,
      title: _partner.isEmpty()
          ? const Text('Adauga Partener')
          : const Text('Editeaza Partener', style: CustomStyle.titleText),
      content: Container(
        width: 400,
        //height: 600,
        child: Column(
          children: [
            const SizedBox(
              height: 8,
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              CustomDropdown(
                labelText: 'Tip Partener *',
                hintText: '',
                initialValue: PartnerType.company,
                onValueChanged: (value) {
                  setState(() {
                    _partner.type = value.name!;
                  });
                },
                dataList: PartnerType.partnerTypes,
              ),
              const SizedBox(
                height: 16,
              ),
              CustomTextField(
                labelText: "Cod (optional)",
                hintText: null,
                initialValue: _partner.code,
                onValueChanged: (String value) {
                  _partner.code = value;
                },
              ),
              const SizedBox(
                height: 16,
              ),
              CustomTextField(
                key: nameFormKey,
                labelText: "Denumire *",
                hintText: null,
                initialValue: _partner.name,
                onValueChanged: (String value) {
                  _partner.name = value;
                },
                errorText: "Camp obligatoriu",
              ),
              const SizedBox(
                height: 16,
              ),
              CustomTextField(
                key: taxIdFormKey,
                labelText: "CIF / CNP *",
                hintText: null,
                initialValue: _partner.taxId,
                onValueChanged: (String value) {
                  setState(() {
                    _partner.taxId = value;
                  });
                },
                errorText: "Camp obligatoriu",
              ),
              Visibility(
                visible: _currentSelection == 'company',
                child: const SizedBox(
                  height: 16,
                ),
              ),
              CustomTextField(
                labelText: "Nr.Reg.Com. (optional)",
                hintText: null,
                initialValue: _partner.companyNumber,
                enabled: _partner.type == PartnerType.company.name,
                onValueChanged: (String value) {
                  setState(() {
                    _partner.companyNumber = value;
                  });
                },
              ),
              const SizedBox(
                height: 16,
              ),
              CustomCheckbox(
                  value: _partner.isActive,
                  labelText: "Activ",
                  onChanged: (value) {
                    setState(() {
                      _partner.isActive = value;
                    });
                  }),
              const SizedBox(
                height: 32,
              ),
              CustomTabBar(
                tabController: _tabController,
                tabs: const [
                  Tab(
                    text: 'Adresa',
                  ),
                  Tab(text: 'Cont bancar'),
                ],
              ),
              SizedBox(
                height: 100,
                child: TabBarView(
                  controller: _tabController,
                  children: const <Widget>[
                    Center(
                      child: Text("Tab1"),
                    ),
                    Center(
                      child: Text("Tab2"),
                    ),
                  ],
                ),
              ),
            ]),

            //
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            if (nameFormKey.currentState!.valid()) {
              if (_partner.type == PartnerType.company.name) {
                if (taxIdFormKey.currentState!.valid()) {
                  _savePartner(_partner);
                }
              } else if (_partner.type == PartnerType.individual.name) {
                _savePartner(_partner);
              }
            }
          },
          child: const Text('Save'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the popup
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
