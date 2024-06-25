import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/pages/item/item_details_page.dart';
import 'package:erp_frontend_v2/pages/item/widgets/item_page_data_table.dart';
import 'package:erp_frontend_v2/widgets/buttons/primary_button.dart';
import 'package:erp_frontend_v2/widgets/custom_search_bar.dart';
import 'package:erp_frontend_v2/widgets/custom_tab_bar.dart';
import 'package:flutter/material.dart';
import '../../utils/responsiveness.dart';

class ItemsPage extends StatefulWidget {
  const ItemsPage({super.key});

  @override
  State<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _searchText;
  String? _status;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomColor.white,
      padding: EdgeInsets.only(
        left: ResponsiveWidget.isSmallScreen(context) ? 0 : 24,
        right: ResponsiveWidget.isSmallScreen(context) ? 0 : 24,
        top: ResponsiveWidget.isSmallScreen(context) ? 24 : 24,
        bottom: ResponsiveWidget.isSmallScreen(context) ? 0 : 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Produse',
                  style: CustomStyle.titleText,
                ),
              ),

              //const Spacer(),

              // Adjust the spacing between the buttons
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: CustomSearchBar(
                        hintText: "Cauta dupa cod sau denumire produs",
                        onValueChanged: (value) {
                          setState(() {
                            _searchText = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    PrimaryButton(
                      text: 'Adauga',
                      icon: Icons.add,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const ItemDetailsPopup(
                              item: null,
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 36),
          CustomTabBar(
            tabController: _tabController,
            tabs: const [
              Tab(text: 'Toate'),
              Tab(text: 'Active'),
              Tab(text: 'Inactive'),
            ],
          ),
          const SizedBox(height: 36),
          Expanded(
              child: ItemsDataTable(
            searchText: _searchText,
            status: _status,
          ))
        ],
      ),
    );
  }
}
