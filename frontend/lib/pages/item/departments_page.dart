import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/pages/item/widgets/departments_data_table.dart';
import 'package:erp_frontend_v2/pages/item/widgets/item_unit_popup.dart';

import 'package:erp_frontend_v2/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../utils/responsiveness.dart';

class DepartmentsPage extends StatefulWidget {
  const DepartmentsPage({super.key});

  @override
  State<DepartmentsPage> createState() => _DepartmentsPageState();
}

class _DepartmentsPageState extends State<DepartmentsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(
              'departments'.tr(context),
              style: CustomStyle.medium40(),
            ),
            const Spacer(),
            PrimaryButton(
              text: 'add'.tr(context),
              icon: Icons.add,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const DepartmentPopup(
                      department: null,
                    );
                  },
                );
              },
            ),
          ],
        ),
        const Gap(24),
        const Flexible(
          child: DepartmentsDataTable(),
        )
      ],
    );
  }
}
