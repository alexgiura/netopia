import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:math';

import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/routing/routes.dart';
import 'package:erp_frontend_v2/utils/extensions.dart';
import 'package:erp_frontend_v2/utils/responsiveness.dart';
import 'package:erp_frontend_v2/widgets/custom_line_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';

///An Expansion style [ListTile] card which will look much better than
///traditional ExpansionTile, with some customization options
class Expandile extends StatefulWidget {
  ///Primary color of the [title], card, arrow widgets;
  final Color primaryColor;

  ///Custom text color on valid values;
  final Color? validTextColor;

  ///Title widget to be shown
  final String title;

  ///Optional title style
  final TextStyle? titleStyle;

  ///Optional description widget to be shown
  final String? description;

  ///Children to be shown when expanded
  final List<Widget> children;

  ///OPtional static widget to be shown on the footer even on closed state
  final Widget? footer;

  ///To automatically hide the expandile based on requirement
  final bool autoHide;

  ///Time to auto hide the expandile widget in [milliseconds]
  final int autoHideDuration;

  ///Function to be executed when tapping the [ListTile]
  final VoidCallback? onTap;

  ///Optional [Widget] or [IconData] to be used as [Leading]
  final dynamic leading;

  ///Card elevation value
  final double elevation;

  ///Padding to be given between [ListTile] children
  final EdgeInsetsGeometry? contentPadding;

  ///To expand the widget initially
  final bool initialyExpanded;

  ///MaxLines to control the description length
  final int? maxDescriptionLines;

  ///If the content or function is executed and the selection is valid,
  ///so we need to make the [ListTile] as currently selected/completed/done.
  final bool isValid;

  ///Outter padding of the widget
  final EdgeInsets? padding;

  final bool trailingIcon;
  final bool expanded;

  const Expandile(
      {Key? key,
      required this.primaryColor,
      this.validTextColor,
      required this.title,
      this.titleStyle,
      this.description,
      this.children = const <Widget>[],
      this.footer,
      this.autoHide = false,
      this.autoHideDuration = 5000,
      this.trailingIcon = true,
      this.expanded = false,

      ///5 Seconds
      this.onTap,
      this.leading,
      this.elevation = 0.0,
      this.contentPadding,
      this.initialyExpanded = false,
      this.maxDescriptionLines,
      this.isValid = false,
      this.padding})
      : super(key: key);

  @override
  State<Expandile> createState() => _ExpandileState();
}

class _ExpandileState extends State<Expandile> {
  final OverlayPortalController overlayPortalController =
      OverlayPortalController();
  final GlobalKey parentKey = GlobalKey();
  bool expanded = false;
  Color cardColor = Colors.transparent;

  Color get textColor => widget.isValid
      ? (widget.validTextColor ?? Colors.white)
      : widget.primaryColor;

  @override
  void initState() {
    expanded = widget.initialyExpanded || widget.expanded;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant Expandile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.expanded != widget.expanded) {
      setState(() {
        expanded = widget.expanded;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color selectedColor = widget.primaryColor.withOpacity(0.12);

    return Padding(
      padding: widget.padding ?? const EdgeInsets.symmetric(vertical: 0),
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: expanded ? selectedColor : cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: expanded
                    ? widget.primaryColor.withOpacity(0.16)
                    : Colors.transparent,
                width: 0.5,
              ),
            ),
            child: MouseRegion(
              onEnter: (_) {
                setState(() => cardColor = selectedColor);
              },
              onExit: (_) {
                setState(() => cardColor = Colors.transparent);
              },
              child: infoTile(),
            ),
          ),
          childrenWidgets(),
          footerWidget(),
        ],
      ),
    );
  }

  Widget infoTile() {
    return MouseRegion(
      cursor: SystemMouseCursors.cell,
      child: GestureDetector(
        onTap: widget.onTap ?? () => changeExpansionFn(),
        child: Container(
          color: Colors.transparent,
          child: ListTile(
            autofocus: false,
            contentPadding: widget.contentPadding,
            leading: _leading(),
            title: _infoTitle(),
            subtitle: _infoSubtitle(),
            trailing: widget.trailingIcon ? _expansionButton() : null,
          ),
        ),
      ),
    );
  }

  Widget? _leading() {
    if (widget.leading is Widget) return widget.leading as Widget;
    if (widget.leading is IconData) {
      final Icon icon = Icon(
        widget.leading as IconData,
        color: textColor,
      );
      return widget.description == null
          ? icon
          : IconButton(
              icon: icon,
              onPressed: null,
            );
    }
    return null;
  }

  Widget _infoTitle() {
    return Text(
      widget.title,
      style: widget.titleStyle ??
          CustomStyle.medium14(color: CustomColor.textSecondary),
      maxLines: 1,
    );
  }

  Widget? _infoSubtitle() {
    if (widget.description == null) return null;
    return Text(
      widget.description ?? '',
      maxLines: widget.maxDescriptionLines ?? 3,
    );
  }

  Widget _expansionButton() {
    return IconButton(
      icon: const Icon(Icons.arrow_drop_down),
      onPressed: () => changeExpansionFn(),
    );
  }

  Widget childrenWidgets() {
    return CrossFade(
      useCenter: false,
      show: expanded,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.children.length,
        itemBuilder: (context, index) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 11.5),
                child: CustomPaint(
                  size: const Size(30, 50),
                  painter: LinePainter(
                    index: index,
                    itemCount: widget.children.length,
                    color: widget.primaryColor,
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.only(left: 10),
                  child: widget.children[index],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget footerWidget() {
    if (widget.footer == null) return Container();
    return widget.footer!;
  }

  Future<void> changeExpansionFn() async {
    setState(() => expanded = !expanded);
    if (expanded) {
      overlayPortalController.show();
    } else {
      overlayPortalController.hide();
    }
  }
}

class CrossFade extends StatelessWidget {
  final Widget child;
  final Widget? hiddenChild;
  final bool show;
  final EdgeInsets? padding;
  final bool useCenter;

  const CrossFade({
    Key? key,
    required this.child,
    this.hiddenChild,
    this.show = false,
    this.padding,
    this.useCenter = true,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: padding,
        child: AnimatedCrossFade(
          firstChild: hiddenChild ?? Container(),
          secondChild: childX(),
          duration: const Duration(milliseconds: 500),
          crossFadeState:
              show ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        ));
  }

  Widget childX() {
    if (useCenter) return Align(alignment: Alignment.center, child: child);
    return child;
  }
}
