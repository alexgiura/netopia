import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/pages/partner/partner_details_page.dart';
import 'package:erp_frontend_v2/pages/partner/widgets/partner_page_data_table.dart';
import 'package:erp_frontend_v2/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import '../../utils/responsiveness.dart';

class PartnersPage extends StatefulWidget {
  const PartnersPage({super.key});

  @override
  State<PartnersPage> createState() => _PartnersPageState();
}

class _PartnersPageState extends State<PartnersPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'partners'.tr(context),
              style: CustomStyle.medium40(),
            ),
            const Spacer(),
            PrimaryButton(
              text: 'add'.tr(context),
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
          ],
        ),
        const SizedBox(height: 16),
        const Flexible(
          child: PartnerPageDataTable(),
        )
      ],
    );
  }
}
