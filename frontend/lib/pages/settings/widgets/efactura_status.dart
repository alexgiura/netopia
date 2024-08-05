import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class EfacturaStatus extends ConsumerWidget {
  const EfacturaStatus({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);
    return userState.when(
      skipLoadingOnReload: true,
      skipLoadingOnRefresh: true,
      data: (user) {
        return Container(
          alignment: Alignment.center,
          child: Container(
            height: 28,
            decoration: BoxDecoration(
              color: user.eFacturaAuth == true
                  ? CustomColor.green.withOpacity(0.1)
                  : CustomColor.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      user.eFacturaAuth == true
                          ? Icons.check_circle_outline_rounded
                          : Icons.error_outline_rounded,
                      size: 20,
                      color: user.eFacturaAuth == true
                          ? CustomColor.green
                          : CustomColor.error,
                    ),
                    Gap(4),
                    Text(
                        user.eFacturaAuth == true ? 'Autorizat' : 'Neautorizat',
                        style: user.eFacturaAuth == true
                            ? CustomStyle.semibold14(color: CustomColor.green)
                            : CustomStyle.semibold14(color: CustomColor.error)),
                  ],
                ),
              ),
            ),
          ),
        );
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
