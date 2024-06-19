import 'package:erp_frontend_v2/widgets/custom_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../constants/style.dart';

class CustomCheckboxListTile extends StatelessWidget {
  const CustomCheckboxListTile({
    Key? key,
    required this.value,
    required this.onChanged,
    this.title,
    this.subtitle,
  }) : super(key: key);

  final bool value;
  final String? title;
  final String? subtitle;
  final Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: value
          ? CustomStyle.customBorderContainerDecoration()
          : CustomStyle.customContainerDecoration(),
      child: InkWell(
        onTap: () {
          onChanged(!value);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomCheckbox(
                  value: value,
                  onChanged: (value) {
                    onChanged(value);
                  }),
              Gap(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title != null)
                      Text(
                        title!,
                        style: CustomStyle.bold14(),
                      ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: CustomStyle.regular14(
                          color: CustomColor.slate_500,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
