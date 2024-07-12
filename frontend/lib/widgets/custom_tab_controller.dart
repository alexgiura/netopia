import 'package:erp_frontend_v2/widgets/custom_tab_bar.dart';
import 'package:flutter/material.dart';

class CustomTabControllerWidget extends StatefulWidget {
  final List<Text> tabs;
  final ValueChanged<List<bool>> onStatusChanged;
  final int initialIndex;

  CustomTabControllerWidget({
    required this.tabs,
    required this.onStatusChanged,
    this.initialIndex = 0,
  });

  @override
  _CustomTabControllerWidgetState createState() =>
      _CustomTabControllerWidgetState();
}

class _CustomTabControllerWidgetState extends State<CustomTabControllerWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<bool> _selectStatus = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.tabs.length,
      vsync: this,
      initialIndex: widget.initialIndex,
    );

    _updateSelectStatus(_tabController.index);
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _updateSelectStatus(_tabController.index);
        });
        widget.onStatusChanged(_selectStatus);
      }
    });
  }

  void _updateSelectStatus(int selectedIndex) {
    _selectStatus = [];
    switch (selectedIndex) {
      case 0:
        _selectStatus.add(true);
        break;
      case 1:
        _selectStatus.add(false);
        break;
      case 2:
        _selectStatus.add(true);
        _selectStatus.add(false);
        break;
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTabBar(
      tabController: _tabController,
      tabs: widget.tabs.map((textWidget) => Tab(child: textWidget)).toList(),
    );
  }
}
