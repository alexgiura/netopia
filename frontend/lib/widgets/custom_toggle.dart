// import 'package:erp_frontend_v2/constants/style.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:gap/gap.dart';
// import 'package:material_symbols_icons/symbols.dart';

// class CustomToggle extends StatefulWidget {
//   final String title;
//   final String? subtitle;
//   final bool? initialValue;
//   final ValueChanged<bool> onChanged;

//   const CustomToggle({
//     Key? key,
//     required this.title,
//     this.subtitle,
//     this.initialValue,
//     required this.onChanged,
//   }) : super(key: key);

//   @override
//   State<CustomToggle> createState() => _CustomToggleState();
// }

// class _CustomToggleState extends State<CustomToggle> {
//   bool _value = true;

//   @override
//   void initState() {
//     super.initState();

//     _value = widget.initialValue ?? true;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Text(
//               widget.title,
//               style: CustomStyle.regular16(),
//             ),
//             Gap(8),
//             Container(
//               constraints: BoxConstraints(maxHeight: 24),
//               child: CupertinoSwitch(
//                 value: _value,
//                 onChanged: (bool newValue) {
//                   setState(() {
//                     _value = newValue;
//                   });
//                   widget.onChanged(newValue);
//                 },

//                 thumbColor: _value
//                     ? CustomColor.textPrimary
//                     : CustomColor.textSecondary,
//                 activeColor: CustomColor.slate_200, // Circle color when active
//                 trackColor: CustomColor.slate_200, // Track color when inactive

//               ),
//             ),
//           ],
//         ),
//         if (widget.subtitle != null) ...[
//           Text(widget.subtitle!,
//               style: CustomStyle.labelSemibold12(color: CustomColor.slate_400)),
//         ],
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:erp_frontend_v2/constants/style.dart'; // Adjust import as necessary
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/symbols.dart';

class CustomToggle extends StatefulWidget {
  final String title;
  final String? subtitle;
  final bool initialValue;
  final ValueChanged<bool> onChanged;

  const CustomToggle({
    Key? key,
    required this.title,
    this.subtitle,
    this.initialValue = true,
    required this.onChanged,
  }) : super(key: key);

  @override
  _CustomToggleState createState() => _CustomToggleState();
}

class _CustomToggleState extends State<CustomToggle> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  void _toggleSwitch() {
    setState(() {
      _value = !_value;
    });
    widget.onChanged(_value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: CustomStyle.regular16(),
            ),
            const Gap(16),
            GestureDetector(
              onTap: _toggleSwitch,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 40.0,
                height: 20.0,
                padding: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: _value
                      ? CustomColor.slate_200 // Active track color
                      : CustomColor.slate_200, // Inactive track color
                ),
                child: Stack(
                  children: [
                    AnimatedAlign(
                      duration: const Duration(milliseconds: 200),
                      alignment:
                          _value ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        width: 16.0,
                        height: 16.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _value
                              ? CustomColor.textPrimary // Active thumb color
                              : CustomColor.slate_400, // Inactive thumb color
                        ),
                        child: _value
                            ? const Icon(
                                Symbols.check_rounded,
                                size: 12,
                                fill: 1,
                                weight: 600,
                                opticalSize: 24,
                                color: CustomColor
                                    .accentColor, // Icon color when active
                              )
                            : const Icon(
                                Symbols.close_rounded,
                                size: 12,
                                fill: 1,
                                weight: 600,
                                opticalSize: 24,
                                color: CustomColor
                                    .textSecondary, // Icon color when active
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const Gap(8),
        if (widget.subtitle != null) ...[
          Text(
            widget.subtitle!,
            style: CustomStyle.semibold12(color: CustomColor.slate_400),
          ),
        ],
      ],
    );
  }
}
