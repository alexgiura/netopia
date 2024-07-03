import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class StepIndicator extends ConsumerStatefulWidget {
  const StepIndicator({
    required this.totalSteps,
    required this.currentStep,
    this.stepTitle,
    this.stepSubTitle,
    super.key,
  });

  final int totalSteps;
  final int currentStep;
  final List<String>? stepTitle;
  final List<String>? stepSubTitle;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StepIndicatorState();
}

class _StepIndicatorState extends ConsumerState<StepIndicator> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.currentStep + 1} din ${widget.totalSteps} etape',
              style: CustomStyle.semibold12(color: CustomColor.slate_500),
            ),
            Container(
              width: double.maxFinite,
              height: context.height01 * 0.6,
              decoration: BoxDecoration(
                color: CustomColor.textPrimary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: constraints.maxWidth *
                      ((widget.currentStep + 1) /
                          widget
                              .totalSteps), // here is the change in width based on the current step and total steps
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: CustomColor.textPrimary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            if (widget.stepTitle != null &&
                widget.stepTitle!.length == widget.totalSteps)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Gap(16),
                  Text(widget.stepTitle![widget.currentStep],
                      style: CustomStyle.medium32()),
                  if (widget.stepSubTitle != null &&
                      widget.stepSubTitle!.length == widget.totalSteps)
                    Text(widget.stepSubTitle![widget.currentStep],
                        style: CustomStyle.regular16(
                            color: CustomColor.slate_500)),
                ],
              )
          ],
        );
      },
    );
  }
}
