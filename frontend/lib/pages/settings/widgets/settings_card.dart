import 'package:erp_frontend_v2/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SettingsCard extends StatefulWidget {
  final IconData iconData;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Widget? statusWidget;

  const SettingsCard(
      {Key? key,
      required this.iconData,
      required this.title,
      required this.subtitle,
      required this.onTap,
      this.statusWidget})
      : super(key: key);

  @override
  State<SettingsCard> createState() => SettingsCardState();
}

class SettingsCardState extends State<SettingsCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align items to the start of the row
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: CustomColor.accentColor.withOpacity(0.4),
                    child: Icon(
                      widget.iconData,
                      color: Colors.black,
                    ),
                  ),
                  widget.statusWidget ?? Container()
                ],
              ),
              Gap(16.0),
              Text(
                widget.title,
                style: CustomStyle.bold20(),
              ),
              Gap(8.0),
              Text(
                widget.subtitle,
                style: CustomStyle.regular14(color: CustomColor.slate_500),
                softWrap: true, // Allow text to wrap
                overflow: TextOverflow.visible, // Handle overflow gracefully
              ),
            ],
          ),
        ),
      ),
    );
  }
}
