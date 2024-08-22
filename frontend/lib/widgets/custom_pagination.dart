import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:flutter/material.dart';

class CustomPagination extends StatefulWidget {
  final int itemCount;
  final int itemsPerPage;
  final Future<void> Function(int)? asyncOnPressed;
  final int rowsCount;

  const CustomPagination({
    super.key,
    required this.itemCount,
    required this.rowsCount,
    this.itemsPerPage = 10,
    required this.asyncOnPressed,
  });

  @override
  State<CustomPagination> createState() => _CustomPaginationState();
}

class _CustomPaginationState extends State<CustomPagination> {
  int _currentPage = 0;

  @override
  void didUpdateWidget(covariant CustomPagination oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.itemCount != widget.itemCount) {
      setState(() {
        _currentPage = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalPages = (widget.itemCount / widget.itemsPerPage).ceil();

    int endItem = (_currentPage + 1) * widget.itemsPerPage;
    if (endItem > widget.itemCount) {
      endItem = widget.itemCount;
    }

    List<Widget> buttons = List.generate(totalPages, (index) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_currentPage == index ? 12 : 24),
          border: Border.all(
            color:
                _currentPage == index ? CustomColor.bgDark : Colors.transparent,
            width: 2,
          ),
        ),
        child:
            _currentPage == index ? _outlinedButton(index) : _textButton(index),
      );
    }).toList();

    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 16, right: 35),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${'showing'.tr(context)} $endItem ${'out_of'.tr(context)} ${widget.itemCount} ${'items_entries'.tr(context)}',
            style: CustomStyle.regular12(color: CustomColor.greenGray),
          ),
          Flexible(
            flex: 12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                widget.itemCount != 0
                    ? _iconButton(
                        icon: Icons.arrow_back_ios_new_rounded,
                        totalPages: totalPages,
                        direction: 'back')
                    : Container(),
                ...buttons,
                widget.itemCount != 0
                    ? _iconButton(
                        icon: Icons.arrow_forward_ios_rounded,
                        totalPages: totalPages,
                        direction: 'next')
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _outlinedButton(index) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.all(0),
        backgroundColor: CustomColor.bgPrimary, // Highlight current page
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9),
        ),
      ),
      onPressed: widget.asyncOnPressed != null
          ? () async {
              setState(() {
                _currentPage = index;
              });
              await widget.asyncOnPressed!(index);
            }
          : null,
      child: Center(
        child: Text(
          '${index + 1}',
          style: CustomStyle.semibold14(color: CustomColor.bgDark),
        ),
      ),
    );
  }

  Widget _textButton(index) {
    return TextButton(
      style: ButtonStyle(
        backgroundColor:
            WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
          return CustomColor.slate_50;
        }),
        overlayColor:
            WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
          if (states.contains(WidgetState.hovered) ||
              states.contains(WidgetState.focused)) {
            return Colors.transparent;
          } else {
            return CustomColor.slate_50;
          }
        }),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
      onFocusChange: null,
      onPressed: widget.asyncOnPressed != null
          ? () async {
              setState(() {
                _currentPage = index;
              });
              await widget.asyncOnPressed!(index);
            }
          : null,
      child: Center(
        child: Text(
          '${index + 1}',
          style: CustomStyle.semibold14(color: CustomColor.textPrimary),
        ),
      ),
    );
  }

  Widget _iconButton(
      {required IconData icon,
      required int totalPages,
      required String direction}) {
    return IconButton(
      icon: Icon(icon, size: 16),
      onPressed: direction == 'next'
          ? _currentPage < totalPages - 1
              ? () async {
                  setState(() {
                    _currentPage++;
                  });
                  await widget.asyncOnPressed!(_currentPage);
                }
              : null
          : _currentPage > 0
              ? () async {
                  setState(() {
                    _currentPage--;
                  });
                  await widget.asyncOnPressed!(_currentPage);
                }
              : null,
    );
  }
}
