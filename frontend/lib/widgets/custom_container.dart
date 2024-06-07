import 'package:flutter/material.dart';

import '../constants/style.dart';

class CustomContainer extends StatefulWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  const CustomContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
  });

  @override
  State<CustomContainer> createState() => _CustomContainerState();
}

class _CustomContainerState extends State<CustomContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: widget.padding ?? const EdgeInsets.all(30),
        margin: widget.margin,
        width: widget.width,
        height: widget.height,
        decoration: CustomStyle.customStyledContainerDecorationShadow,
        child: widget.child);
  }
}
