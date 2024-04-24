import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/widgets/custom_checkbox.dart';
import 'package:flutter/material.dart';

class CustomListTile extends StatefulWidget {
  final String title;
  final bool? isChecked;
  final ValueChanged<bool> onChanged;

  CustomListTile({
    Key? key,
    required this.title,
    required this.isChecked,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<CustomListTile> createState() => _CustomListTileState();
}

class _CustomListTileState extends State<CustomListTile> {
  bool _isChecked = false;
  bool _isHovering = false; // Add this line

  @override
  void initState() {
    super.initState();
    if (widget.isChecked != null) {
      _isChecked = widget.isChecked!;
    }
  }

  @override
  void didUpdateWidget(CustomListTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isChecked != null) {
      _isChecked = widget.isChecked!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => setState(() => _isHovering = true),
      onExit: (event) => setState(() => _isHovering = false),
      child: InkWell(
        onTap: () {
          setState(() {
            _isChecked = !_isChecked;
          });
          widget.onChanged(_isChecked);
        },
        child: Container(
          decoration: BoxDecoration(
              color: _isHovering ? CustomColor.lightest : Colors.transparent,
              borderRadius: CustomStyle.customBorderRadius),
          padding: EdgeInsets.fromLTRB(8, 8, 0, 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              widget.isChecked != null
                  ? Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: CustomCheckbox(
                        value: _isChecked,
                        onChanged: (bool newValue) {
                          setState(() {
                            _isChecked = newValue;
                          });
                          widget.onChanged(newValue);
                        },
                        labelText: '',
                      ),
                    )
                  : SizedBox.shrink(),
              Expanded(
                child: Text(
                  widget.title,
                  style: CustomStyle.bodyText, // Replace with your text style
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
