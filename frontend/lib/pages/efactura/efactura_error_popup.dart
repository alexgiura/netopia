import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/widgets/buttons/primary_button.dart';
import 'package:erp_frontend_v2/widgets/buttons/secondary_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class EfacturaErrorPopup extends StatefulWidget {
  const EfacturaErrorPopup({super.key});

  @override
  State<EfacturaErrorPopup> createState() => _EfacturaInfoPopupState();
}

class _EfacturaInfoPopupState extends State<EfacturaErrorPopup> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 400,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    color: CustomColor.error,
                    size: 64,
                  ),
                  const Spacer(),
                  InkWell(
                    child: const Icon(Icons.close),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              const Gap(16.0),
              Text(
                'e_factura_error'.tr(context),
                style: CustomStyle.bold20(),
              ),
              const Gap(4.0),
              Text(
                'e_factura_error_description'.tr(context),
                style: CustomStyle.regular14(color: CustomColor.slate_500),
                softWrap: true, // Allow text to wrap
                overflow: TextOverflow.visible, // Handle overflow gracefully
              ),
              const Gap(32.0),

              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: CustomStyle.customContainerDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.error_outline_rounded,
                          color: CustomColor.error,
                          size: 20,
                        ),
                        const Gap(4),
                        Text(
                          '${'possible_causes'.tr(context)}:',
                          style: CustomStyle.bold14(),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 20,
                            width: 20,
                            child: const Center(child: Text('\u2022')),
                          ),
                          const Gap(4),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('token_not_activated'.tr(context),
                                    style: CustomStyle.medium14())
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 20,
                            width: 20,
                            child: const Center(child: Text('\u2022')),
                          ),
                          const Gap(4),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'token_not_confirmed_anaf'.tr(context),
                                  style: CustomStyle.medium14(),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 20,
                            width: 20,
                            child: const Center(child: Text('\u2022')),
                          ),
                          const Gap(4),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'cert_not_selected_or_pin_incorrect'
                                        .tr(context),
                                    style: CustomStyle.medium14())
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const Gap(16),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: CustomStyle.customContainerDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.refresh_rounded,
                          color: CustomColor.green,
                          size: 20,
                        ),
                        const Gap(4),
                        Text(
                          'retry_authorization'.tr(context),
                          style: CustomStyle.bold14(),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 20,
                            width: 20,
                            child: Center(
                                child:
                                    Text(' 1.', style: CustomStyle.medium14())),
                          ),
                          const Gap(4),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('close_browser_windows'.tr(context),
                                    style: CustomStyle.medium14())
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 20,
                            width: 20,
                            child: Center(
                                child:
                                    Text(' 2.', style: CustomStyle.medium14())),
                          ),
                          const Gap(4),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'reopen_browser_incognito'.tr(context),
                                  style: CustomStyle.medium14(),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 20,
                            width: 20,
                            child: Center(
                                child:
                                    Text(' 3.', style: CustomStyle.medium14())),
                          ),
                          const Gap(4),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('retry_authorization_process'.tr(context),
                                    style: CustomStyle.medium14())
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),

              //
              const Gap(32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SecondaryButton(
                      text: 'back'.tr(context),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  const Gap(16),
                  Expanded(
                    child: PrimaryButton(
                      text: 'retry'.tr(context),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
