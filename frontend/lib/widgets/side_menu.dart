import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/utils/extensions.dart';
import 'package:erp_frontend_v2/utils/responsiveness.dart';
import 'package:erp_frontend_v2/widgets/buttons/primary_button.dart';
import 'package:erp_frontend_v2/widgets/custom_expansiontile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
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
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            _topLogo(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 40, right: 40, bottom: 40),
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
                            padding: const EdgeInsets.only(top: 0),
                            itemCount: data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return _buildMenuList(data[index]);
                            },
                          ),
                        ),
                        _bottomSection(),
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

  Widget _bottomSection() {
    if (context.deviceWidth >= mediumScreenSize) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        width: double.infinity,
        height: 166,
        decoration: BoxDecoration(
          color: CustomColor.bgPrimary.withOpacity(0.12),
          border: Border.all(
            color: CustomColor.bgPrimary.withOpacity(0.16),
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(28),
        ),
        margin: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Emite e-Facturi',
              style: CustomStyle.semibold16(color: CustomColor.bgSecondary),
            ),
            Text(
              'Autorizează accesul in S.P.V. pentru emiterea e-Facturilor',
              style: CustomStyle.regular12(color: CustomColor.bgPrimary),
            ),
            Container(
              width: double.infinity,
              child: PrimaryButton(
                text: 'Autorizează',
                style: CustomStyle.ctaButton,
                fontColor: CustomColor.bgDark,
              ),
            ),
          ],
        ),
      );
    }
    return Container();
  }

  Container _topLogo() {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 32),
      width: 104,
      child: Image.asset(
        'assets/images/logo.png',
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildMenuList(Menu menuItem) {
    return menuItem.children.isNotEmpty
        ? Expandile(
            autoHide: true,
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
            children: menuItem.children.map(_buildMenuList).toList(),
          )
        : Builder(builder: (context) {
            Color _cardColor = Colors.transparent;
            Color _selectedColor = CustomColor.bgPrimary.withOpacity(0.16);
            return Container(
              decoration: BoxDecoration(
                  color: selectedIndex == menuItem.id
                      ? _selectedColor
                      : _cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: selectedIndex == menuItem.id
                          ? CustomColor.bgPrimary.withOpacity(0.16)
                          : Colors.transparent,
                      width: 0.5)),
              child: MouseRegion(
                onHover: (event) {
                  setState(() {
                    _cardColor = CustomColor.bgPrimary.withOpacity(0.12);
                  });
                },
                onExit: (event) {
                  setState(() {
                    _cardColor = Colors.transparent;
                  });
                },
                child: ListTile(
                  /// Here we are checking if the current menu item is selected or not and styling accordingly
                  leading: menuItem.icon != null
                      ? Icon(menuItem.icon, color: CustomColor.textSecondary)
                      : null,
                  title: Text(menuItem.title,
                      style: CustomStyle.medium14(
                          color: CustomColor.textSecondary)),
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
                ),
              ),
            );
          });
  }
}
