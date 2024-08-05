import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/providers/user_provider.dart';
import 'package:erp_frontend_v2/utils/extensions.dart';
import 'package:erp_frontend_v2/utils/responsiveness.dart';
import 'package:erp_frontend_v2/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuEfacturaWidget extends ConsumerWidget {
  const MenuEfacturaWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);
    return userState.when(
      skipLoadingOnReload: true,
      skipLoadingOnRefresh: true,
      data: (user) {
        if (context.deviceWidth >= mediumScreenSize && !user.eFacturaAuth) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            width: double.infinity,
            height: 166,
            decoration: BoxDecoration(
              color: CustomColor.bgPrimary.withOpacity(0.12),
              border: Border.all(
                color: CustomColor.bgPrimary.withOpacity(0.16),
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(28),
            ),
            margin: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'emit_eInvoice'.tr(context),
                  style:
                      CustomStyle.semibold16(color: CustomColor.textSecondary),
                ),
                Text(
                  'authotize_SPV_access__for_emit_eInvoice'.tr(context),
                  style:
                      CustomStyle.regular12(color: CustomColor.textSecondary),
                ),
                Container(
                  width: double.infinity,
                  child: PrimaryButton(
                    text: 'authorize_access'.tr(context),
                    style: CustomStyle.ctaButton,
                    fontColor: CustomColor.textPrimary,
                  ),
                ),
              ],
            ),
          );
        }
        return Container();
      },
      loading: () {
        return Container();
      },
      error: (error, stackTrace) {
        return Container();
      },
    );
  }
}
