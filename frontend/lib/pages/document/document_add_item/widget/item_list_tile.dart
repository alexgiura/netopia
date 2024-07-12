import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/models/item/item_model.dart';
import 'package:erp_frontend_v2/widgets/custom_checkbox.dart';
import 'package:flutter/material.dart';

class ItemListTile extends StatefulWidget {
  final Item item;
  final bool? isChecked;
  final ValueChanged<bool> onChanged;

  ItemListTile({
    Key? key,
    required this.item,
    required this.isChecked,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<ItemListTile> createState() => _CustomListTileState();
}

class _CustomListTileState extends State<ItemListTile> {
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
  void didUpdateWidget(ItemListTile oldWidget) {
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
          padding: EdgeInsets.fromLTRB(8, 8, 12, 8),
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
                flex: 2,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.item.name,
                      style: CustomStyle.semibold14(),
                    ),
                    Text(
                      widget.item.um.name,
                      style: CustomStyle.semibold12(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    widget.item.isStock ? 'is_stock'.tr(context) : '',
                    style: CustomStyle.semibold12(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
