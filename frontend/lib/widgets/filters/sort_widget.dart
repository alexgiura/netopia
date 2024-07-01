import 'package:erp_frontend_v2/constants/sizes.dart';
import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class SelectColumns extends StatefulWidget {
  const SelectColumns({super.key});

  @override
  State<SelectColumns> createState() => _SelectColumnsState();
}

class _SelectColumnsState extends State<SelectColumns> {
  @override
  Widget build(BuildContext context) {
    final layerLink = LayerLink(); // I use to attach dropdown to textField
    return CompositedTransformTarget(
      link: layerLink,
      child: InkWell(
        child: Container(
          padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
          height: CustomSize.filterHeight,
          //color: CustomColor.white,
          decoration: CustomStyle.customContainerDecoration(border: true),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                child: const Center(
                  child: Icon(
                    Icons.sort_rounded,
                    size: 20,
                    color: CustomColor.darkest,
                  ),
                ),
              ),
              // Icon(
              //   Icons.filter_list_rounded,
              //   //size: 24,
              //   color: CustomColor.darkest,
              // ),
              // SizedBox(
              //   width: 8,
              // ),
              const Text(
                "Columns",
                style: CustomStyle.labelText,
              )
              // CustomTextField(
              //   prefixIcon: Icons.filter_list_rounded,
              //   enabled: false,
              // )
            ],
          ),
        ),
        onTap: () {
          //showOverlay();
        },
      ),
    );
  }
}
