import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/pages/partner/partner_details_page.dart';
import 'package:erp_frontend_v2/pages/partner/widgets/partner_page_data_table.dart';
import 'package:erp_frontend_v2/widgets/buttons/primary_button.dart';
import 'package:erp_frontend_v2/widgets/buttons/secondary_button.dart';
import 'package:erp_frontend_v2/widgets/filter_section/filter_section_large_partner.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/partner/partner_model.dart';
import '../../helpers/responsiveness.dart';
import '../../models/partner/partner_filter_model.dart';
import '../../services/partner.dart';

class PartnersPage extends StatefulWidget {
  const PartnersPage({super.key});

  @override
  State<PartnersPage> createState() => _PartnersPageState();
}

class _PartnersPageState extends State<PartnersPage> {
  // late bool _isLoading = false;
  // late List<Partner> _partners = [];
  // PartnerFilter _partnerFilter = PartnerFilter.empty();

  // void _handleFilterChange(String name, String type, String taxId) {
  //   // _partnerFilter.code = code;
  //   _partnerFilter.name = name;
  //   _partnerFilter.type = type;
  //   _partnerFilter.taxId = taxId;
  // }

  // void _handleFetchPartners() {
  //   _fetchPartners();
  // }

  @override
  void initState() {
    super.initState();
    // _isLoading = true;
    // _fetchPartners();
  }

  // Future<void> _fetchPartners() async {
  //   try {
  //     final partnerService = PartnerService();
  //     final partners =
  //         await partnerService.getPartners(partnerFilter: _partnerFilter);

  //     setState(() {
  //       _partners = partners;
  //       _isLoading = false;
  //     });
  //   } catch (error) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomColor.white,
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
                'Parteneri',
                style: CustomStyle.titleText,
              ),
              const Spacer(),
              PrimaryButton(
                text: 'Adauga',
                icon: Icons.add,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const PartnerDetailsPopup(
                        partner: null,
                      );
                    },
                  );
                },
              ),
              const SizedBox(width: 8),
              SecondaryButton(
                  text: 'Exportă',
                  icon: Icons.file_download_outlined,
                  onPressed: () {})
            ],
          ),
          const SizedBox(height: 16),
          const Expanded(
            child: PartnerPageDataTable(),
          )
        ],
      ),
    );
  }
}
