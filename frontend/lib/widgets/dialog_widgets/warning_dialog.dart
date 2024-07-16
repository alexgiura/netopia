import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/widgets/buttons/primary_button.dart';
import 'package:erp_frontend_v2/widgets/buttons/secondary_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class WarningCustomDialog extends StatelessWidget {
  final String title;
  final String subtitle;
  final String primaryButtonText;
  final VoidCallback? primaryButtonAction;
  final Future<void> Function()? asyncPrimaryButtonAction;

  final String secondaryButtonText;
  final VoidCallback secondaryButtonAction;

  const WarningCustomDialog({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.primaryButtonText,
    this.primaryButtonAction,
    this.asyncPrimaryButtonAction,
    required this.secondaryButtonText,
    required this.secondaryButtonAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                child: const Icon(Icons.close),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            const Icon(
              Icons.warning_amber_outlined,
              size: 72,
              color: CustomColor.warning, // Customize icon color
            ),
            const Gap(24),
            Text(
              title,
              style: CustomStyle.bold20(color: CustomColor.textPrimary),
              textAlign: TextAlign.center,
            ),
            const Gap(8),
            Text(
              subtitle,
              style: CustomStyle.regular14(color: CustomColor.greenGray),
              textAlign: TextAlign.center,
            ),
            const Gap(40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: SecondaryButton(
                    text: secondaryButtonText,
                    onPressed: secondaryButtonAction,
                  ),
                ),
                Gap(24),
                Expanded(
                  child: PrimaryButton(
                    asyncOnPressed: asyncPrimaryButtonAction,
                    text: primaryButtonText,
                    onPressed: primaryButtonAction,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
