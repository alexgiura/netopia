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

    List<Widget> buttons = _buildPaginationButtons(totalPages);

    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 16, right: 35),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${'showing'.tr(context)} $endItem ${'out_of'.tr(context)} ${widget.itemCount} ${'documents'.tr(context)}',
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
          softWrap: false,
          style: CustomStyle.semibold14(color: CustomColor.textPrimary),
        ),
      ),
    );
  }

  List<Widget> _buildPaginationButtons(int totalPages) {
    List<Widget> buttons = [];

    if (totalPages <= 5) {
      // if there are less than 5 pages, show all pages
      buttons = List.generate(totalPages, (index) {
        return _buildPageButton(index);
      });
    } else {
      // if there are more than 5 pages, we need to decide which pages to show
      if (_currentPage <= 2) {
        // if we are on one of the first 3 pages, show the first 3 pages, the last page and the next page
        buttons = [
          _buildPageButton(0),
          _buildPageButton(1),
          _buildPageButton(2),
          const Text('...'),
          _buildPageButton(totalPages - 1),
        ];
      } else if (_currentPage >= totalPages - 3) {
        // if we are on one of the last 3 pages, show the first page, the last 3 pages and the last page
        buttons = [
          _buildPageButton(0),
          const Text('...'),
          _buildPageButton(totalPages - 3),
          _buildPageButton(totalPages - 2),
          _buildPageButton(totalPages - 1),
        ];
      } else {
        // if we are on any other page, show the first page, the current page, the next page, the last page and the pages before and after the current page
        buttons = [
          _buildPageButton(0),
          const Text('...'),
          _buildPageButton(_currentPage - 1),
          _buildPageButton(_currentPage),
          _buildPageButton(_currentPage + 1),
          const Text('...'),
          _buildPageButton(totalPages - 1),
        ];
      }
    }

    return buttons;
  }

  Widget _buildPageButton(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: 40,
      height: 40,
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
