import 'package:erp_frontend_v2/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/menu_data.dart';
import '../models/menu_model.dart';
import '../routing/router.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  List<Menu> data = [];
  int selectedIndex = -1;

  @override
  void initState() {
    for (var element in dataList) {
      data.add(Menu.fromJson(element));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shadowColor: CustomColor.lightest,
      width: 250,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.zero)),
      backgroundColor: CustomColor.lightest,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "ERP", // Replace with your desired text
              style: CustomStyle.titleText,
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 0),
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildMenuList(data[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuList(Menu menuItem) {
    return menuItem.children.isNotEmpty
        ? ExpansionTile(
            iconColor: CustomColor.darkest,
            textColor: CustomColor.darkest,
            collapsedIconColor: CustomColor.darkest,
            collapsedTextColor: CustomColor.darkest,
            title: ListTile(
              selectedColor: CustomColor.active,
              selectedTileColor: CustomColor.active,
              contentPadding: EdgeInsets.zero,
              leading: menuItem.level == 0 ? Icon(menuItem.icon) : null,
              title: Text(
                menuItem.title,
                style: CustomStyle.menuText,
              ),
            ),
            children: menuItem.children.map(_buildMenuList).toList(),
          )
        : Builder(builder: (context) {
            return ListTile(
              leading: Visibility(
                  visible: menuItem.level == 0 ? true : false,
                  child: Icon(
                    menuItem.icon,
                    color: menuItem.id == selectedIndex
                        ? CustomColor.active
                        : CustomColor.darkest,
                  )),
              title: Text(
                menuItem.title,
                style: menuItem.id == selectedIndex
                    ? CustomStyle.selectedMenuText
                    : CustomStyle.menuText,
              ),
              onTap: () {
                setState(() {
                  selectedIndex =
                      menuItem.id; // Update the selected index on tap
                });
                List<String> route = generateRoute(menuItem);
                context.go(route[0]
                    // , extra: {'screenTitle': route[1]}

                    );
              },
            );
          });
  }
}
