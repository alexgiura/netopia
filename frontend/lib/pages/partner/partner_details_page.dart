import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/models/partner/partner_model.dart';
import 'package:erp_frontend_v2/pages/partner/widgets/partner_details_popup.dart';
import 'package:erp_frontend_v2/providers/partner_provider.dart';
import 'package:erp_frontend_v2/services/partner.dart';
import 'package:erp_frontend_v2/widgets/buttons/edit_button.dart';
import 'package:erp_frontend_v2/widgets/buttons/primary_button.dart';
import 'package:erp_frontend_v2/widgets/custom_header_widget.dart';
import 'package:erp_frontend_v2/widgets/custom_status_chip.dart';
import 'package:erp_frontend_v2/widgets/dialog_widgets/custom_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class PartnerDetailsPage extends ConsumerStatefulWidget {
  final String partnerId;
  const PartnerDetailsPage({super.key, required this.partnerId});

  @override
  ConsumerState<PartnerDetailsPage> createState() => _PartnerDetailsPageState();
}

class _PartnerDetailsPageState extends ConsumerState<PartnerDetailsPage> {
  Partner _partner = Partner.empty();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Partner>>(
      future: PartnerService().getPartners(partnerId: widget.partnerId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            _partner.isEmpty()) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          _partner = snapshot.data![0];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [buildTitle(), const SizedBox(height: 16), buildBody()],
          );
        } else {
          return const Center(child: Text('Document not found'));
        }
      },
    );
  }

  Widget buildTitle() {
    return Row(
      children: [
        CustomHeader(
          title: ('${'partners'.tr(context)} / ${'edit'.tr(context)}'),
          hasBackIcon: true,
        ),
        const Spacer(),
        _partner.isActive == true
            ? PrimaryButton(
                text: 'deactivate'.tr(context),
                icon: Icons.delete_outline_rounded,
                asyncOnPressed: () async {
                  try {
                    _partner.isActive = false;
                    await PartnerService().savePartner(partner: _partner);

                    ref.read(partnerProvider.notifier).refreshPartners();

                    showToast(
                        'suceess_edit_partner'.tr(context), ToastType.success);

                    setState(() {});
                  } catch (e) {
                    showToast('error_try_again'.tr(context), ToastType.error);
                  }
                },
                style: CustomStyle.negativeButtonStyle,
              )
            : PrimaryButton(
                text: 'activate'.tr(context),
                icon: Icons.check_circle_outline_rounded,
                asyncOnPressed: () async {
                  try {
                    _partner.isActive = true;
                    await PartnerService().savePartner(partner: _partner);

                    ref.read(partnerProvider.notifier).refreshPartners();

                    showToast(
                        'suceess_edit_partner'.tr(context), ToastType.success);

                    setState(() {});
                  } catch (e) {
                    showToast('error_try_again'.tr(context), ToastType.error);
                  }
                },
                style: CustomStyle.neutralButtonStyle,
              )
      ],
    );
  }

  Widget buildBody() {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        decoration: CustomStyle.customContainerDecoration(border: true),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  _partner.name,
                  style: CustomStyle.bold32(color: CustomColor.textPrimary),
                ),
                if (_partner.code != null && _partner.code != '') ...[
                  Text(
                    ' #${_partner.code!}',
                    style: CustomStyle.bold32(color: CustomColor.greenGray),
                  ),
                ],
                const Gap(16),
                _partner.isActive == true
                    ? CustomStatusChip(
                        type: StatusType.success, label: 'active'.tr(context))
                    : CustomStatusChip(
                        type: StatusType.error, label: 'inactive'.tr(context)),
                const Spacer(),
              ],
            ),
            const Gap(24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: generalDetails()),
                Expanded(child: address()),
                Expanded(child: bankAccount())
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget generalDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('general_details'.tr(context), style: CustomStyle.medium20()),
            Gap(8),
            CustomEditButton(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return PartnerDetailsPopup(
                      partner: _partner,
                      initialStep: 0,
                      callback: () => setState(() {}),
                    );
                  },
                );
              },
            ),
          ],
        ),
        Gap(16),
        LayoutGrid(
          columnSizes: [auto, 1.fr],
          rowSizes: List.generate(4, (_) => auto), // 4 rows for 4 details
          rowGap: 8.0, // Spacing between rows
          columnGap: 16.0, // Spacing between columns
          children: [
            _buildLabel('${'name'.tr(context)}:'),
            _buildValue(_partner.name),
            _buildLabel('${'partner_type'.tr(context)}:'),
            _buildValue(_partner.type.name),
            _buildLabel('${'vat_personal_number'.tr(context)}:'),
            _buildValue(_partner.vatNumber ?? ''),
            _buildLabel('${'registration_number'.tr(context)}:'),
            _buildValue(_partner.registrationNumber ?? ''),
          ],
        ),
      ],
    );
  }

  Widget address() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('address'.tr(context), style: CustomStyle.medium20()),
            Gap(8),
            CustomEditButton(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return PartnerDetailsPopup(
                      partner: _partner,
                      initialStep: 1,
                      callback: () => setState(() {}),
                    );
                  },
                );
              },
            ),
          ],
        ),
        Gap(16),
        LayoutGrid(
          columnSizes: [auto, 1.fr],
          rowSizes: List.generate(4, (_) => auto), // 4 rows for 4 details
          rowGap: 8.0, // Spacing between rows
          columnGap: 16.0, // Spacing between columns
          children: [
            _buildLabel('${'address'.tr(context)}:'),
            _buildValue(_partner.address?.address ?? ''),
            _buildLabel('${'state'.tr(context)}:'),
            _buildValue(_partner.address?.countyCode ?? ''),
            _buildLabel('${'locality'.tr(context)}:'),
            _buildValue(_partner.address?.locality ?? ''),
          ],
        ),
      ],
    );
  }

  Widget bankAccount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('bank_account'.tr(context), style: CustomStyle.medium20()),
            Gap(8),
            CustomEditButton(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return PartnerDetailsPopup(
                      partner: _partner,
                      initialStep: 2,
                      callback: () => setState(() {}),
                    );
                  },
                );
              },
            ),
          ],
        ),
        Gap(16),
        LayoutGrid(
          columnSizes: [auto, 1.fr],
          rowSizes: List.generate(4, (_) => auto), // 4 rows for 4 details
          rowGap: 8.0, // Spacing between rows
          columnGap: 16.0, // Spacing between columns
          children: [
            _buildLabel('${'bank'.tr(context)}:'),
            _buildValue(_partner.bankAccount?.bank ?? ''),
            _buildLabel('${'iban'.tr(context)}:'),
            _buildValue(_partner.bankAccount?.iban ?? ''),
          ],
        ),
      ],
    );
  }

  Widget _buildLabel(String label) {
    return Text(label,
        style: CustomStyle.regular14(color: CustomColor.slate_500));
  }

  Widget _buildValue(String value) {
    return Text(value, style: CustomStyle.regular16());
  }
}
