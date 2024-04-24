import 'package:flutter/material.dart';

class LargeScreen extends StatefulWidget {
  const LargeScreen({super.key, required this.child});
  final Widget child;
  @override
  State<LargeScreen> createState() => _LargeScreenState();
}

class _LargeScreenState extends State<LargeScreen> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const SizedBox(width: 260, child: Expanded(child: SideMenu())),
        Expanded(flex: 5, child: widget.child)
      ],
    );
  }
}
