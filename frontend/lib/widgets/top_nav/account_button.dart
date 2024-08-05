import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomAccountButton extends ConsumerWidget {
  const CustomAccountButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);

    return InkWell(
      overlayColor: const WidgetStatePropertyAll(
        Colors.transparent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: const ShapeDecoration(
              shape: CircleBorder(),
              color: CustomColor.accentNeutral,
            ),
            child: const Center(
              child: Icon(
                Icons.person_outline,
                size: 24,
              ),
            ),
          ),
          userState.when(
            skipLoadingOnReload: true,
            skipLoadingOnRefresh: true,
            data: (user) {
              return Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  user.company!.name,
                  style: CustomStyle.medium16(),
                ),
              );
            },
            loading: () {
              return Container();
            },
            error: (error, stackTrace) {
              return Container();
            },
          )
        ],
      ),
      onTap: () {
        //
      },
    );
  }
}
