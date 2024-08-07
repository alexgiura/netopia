import 'package:contentsize_tabbarview/contentsize_tabbarview.dart';
import 'package:erp_frontend_v2/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CustomTabBar extends StatefulWidget {
  const CustomTabBar({
    super.key,
    required this.tabs,
    this.tabViews,
    this.sufixButton,
    required this.onChanged,
    this.initialIndex = 0,
  });
  final List<Text> tabs;
  final List<Widget>? tabViews;
  final Widget? sufixButton;
  final ValueChanged<int> onChanged;

  final int initialIndex;

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: widget.tabs.length, vsync: this);
    _tabController.addListener(_handleTabChange);
    _tabController.index = widget.initialIndex;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) return;

    widget.onChanged(_tabController.index);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                height: 36,
                padding: const EdgeInsets.only(
                    top: 0.0, right: 0.0, left: 0.0, bottom: 0.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Theme(
                    data: Theme.of(context),
                    child: TabBar(
                      labelPadding: const EdgeInsets.symmetric(horizontal: 16),
                      isScrollable: true,
                      controller: _tabController,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelColor: CustomColor.textPrimary,
                      unselectedLabelColor: CustomColor.slate_400,
                      indicator: const UnderlineTabIndicator(
                        borderSide: BorderSide(
                          width: 2.0,
                          color: CustomColor.textPrimary,
                        ),
                      ),
                      tabs: widget.tabs
                          .map((textWidget) => Tab(child: textWidget))
                          .toList(),
                    ),
                  ),
                ),
              ),
            ),
            Spacer(),
            if (widget.sufixButton != null) widget.sufixButton!,
          ],
        ),
        if (widget.tabViews != null &&
            widget.tabViews!.length == widget.tabs.length)
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(top: 24),
              child: SingleChildScrollView(
                child: ContentSizeTabBarView(
                  controller: _tabController,
                  children: widget.tabViews!,
                ),
              ),
            ),
          )
      ],
    );
  }
}
