import 'package:erp_frontend_v2/constants/style.dart';
import 'package:flutter/material.dart';

class CustomTabBar extends StatelessWidget {
  CustomTabBar({super.key, required this.tabController, required this.tabs});
  final TabController tabController;
  final List<Tab> tabs;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        height: 36,
        padding:
            const EdgeInsets.only(top: 0.0, right: 0.0, left: 0.0, bottom: 0.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Theme(
            data: Theme.of(context),
            child: TabBar(
                labelPadding: const EdgeInsets.symmetric(horizontal: 16),
                isScrollable: true,
                controller: tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: CustomColor.textPrimary,
                unselectedLabelColor: CustomColor.slate_400,
                indicator: const UnderlineTabIndicator(
                  borderSide: BorderSide(
                    width: 2.0,
                    color: CustomColor.textPrimary,
                  ),
                ),
                tabs: tabs),
          ),
        ),
      ),
    );
  }
}
