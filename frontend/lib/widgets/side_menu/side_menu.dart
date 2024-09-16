import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/utils/extensions.dart';
import 'package:erp_frontend_v2/utils/responsiveness.dart';
import 'package:erp_frontend_v2/widgets/buttons/primary_button.dart';
import 'package:erp_frontend_v2/widgets/custom_expansiontile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../data/menu_data.dart';
import '../../models/menu_model.dart';
import '../../routing/router.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  List<Menu> data = [];
  List<bool> expansionState = [];

  int selectedIndex = -1;
  int hoveredItemIndex = -1;

  @override
  void initState() {
    super.initState();
    for (var element in dataList) {
      data.add(Menu.fromJson(element));
      expansionState.add(false); // Inițializăm fiecare element ca neexpandat
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            _topLogo(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                  bottom: 24,
                ),
                child: Drawer(
                  shadowColor: CustomColor.bgSecondary,
                  width: 256,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(28)),
                  ),
                  backgroundColor: CustomColor.bgDark,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 10,
                          child: ListView.builder(
                            padding: const EdgeInsets.only(top: 20),
                            itemCount: data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return _buildMenuList(data[index], index);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Container _topLogo() {
    return Container(
      margin: const EdgeInsets.only(top: 24, bottom: 24),
      width: 104,
      child: Image.asset(
        'assets/images/netopia-payments.png',
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildMenuList(Menu menuItem, int indexx) {
    return menuItem.children.isNotEmpty
        ? Expandile(
            autoHide: true,
            expanded: expansionState[indexx], // Starea expansiunii

            primaryColor: Colors.white,
            title: menuItem.title,
            titleStyle: CustomStyle.medium14(color: CustomColor.textSecondary),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14),
            trailingIcon: false,
            validTextColor: CustomColor.textSecondary,
            leading: menuItem.level == 0
                ? menuItem.title == "Intrari"
                    ? Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()..scale(-1.0, 1.0),
                        child: Icon(menuItem.icon,
                            color: CustomColor.textSecondary),
                      )
                    : menuItem.icon
                : null,
            children: menuItem.children
                .map((child) => _buildMenuList(child, indexx))
                .toList(),
          )
        : Builder(builder: (context) {
            Color _selectedCard = CustomColor.bgPrimary.withOpacity(0.12);
            return Container(
              decoration: BoxDecoration(
                  color: hoveredItemIndex == menuItem.id
                      ? _selectedCard
                      : selectedIndex == menuItem.id
                          ? _selectedCard
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: selectedIndex == menuItem.id
                          ? CustomColor.bgPrimary.withOpacity(0.16)
                          : Colors.transparent,
                      width: 0.5)),
              child: MouseRegion(
                onHover: (event) {
                  setState(() {
                    hoveredItemIndex = menuItem.id;
                  });
                },
                onExit: (event) {
                  setState(() {
                    hoveredItemIndex = -1;
                  });
                },
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      expansionState[indexx] =
                          !expansionState[indexx]; // Inversăm starea

                      selectedIndex =
                          menuItem.id; // Updatează indexul selectat la clic
                    });
                    List<String> route = generateRoute(menuItem);
                    context.go(route[0]);
                  },
                  child: ListTile(
                    leading: menuItem.icon != null
                        ? Icon(menuItem.icon, color: CustomColor.textSecondary)
                        : null,
                    title: Text(
                      menuItem.title,
                      style: CustomStyle.medium14(
                          color: CustomColor.textSecondary),
                    ),
                  ),
                ),
              ),
            );
          });
  }
}
