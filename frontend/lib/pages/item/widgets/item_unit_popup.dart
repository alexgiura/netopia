import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/models/department_model.dart';
import 'package:erp_frontend_v2/services/departments.dart';
import 'package:erp_frontend_v2/widgets/buttons/primary_button.dart';
import 'package:erp_frontend_v2/widgets/buttons/secondary_button.dart';
import 'package:erp_frontend_v2/widgets/custom_text_field_1.dart';
import 'package:erp_frontend_v2/widgets/custom_toggle.dart';
import 'package:erp_frontend_v2/widgets/department_chip_selector.dart';
import 'package:erp_frontend_v2/widgets/dialog_widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../constants/style.dart';
import '../../../providers/department_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DepartmentPopup extends ConsumerStatefulWidget {
  const DepartmentPopup({super.key, this.department});
  final Department? department;

  @override
  ConsumerState<DepartmentPopup> createState() => _DepartmentPopupState();
}

class _DepartmentPopupState extends ConsumerState<DepartmentPopup>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _itemUnitFormKey = GlobalKey<FormState>();

  late Department _department;

  @override
  void initState() {
    super.initState();
    _department = widget.department ?? Department.empty();
  }

  @override
  Widget build(BuildContext context) {
    // Watch the departmentsProvider to get the list of departments asynchronously
    final departmentsAsyncValue = ref.watch(departmentsProvider);

    return Dialog(
      child: SizedBox(
        width: 450,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _itemUnitFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    widget.department != null
                        ? Text(
                            'edit_department'.tr(context),
                            style: CustomStyle.bold24(),
                          )
                        : Text(
                            'add_department'.tr(context),
                            style: CustomStyle.bold24(),
                          ),
                    const Spacer(),
                    InkWell(
                      child: const Icon(
                        Icons.close,
                        size: 24,
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                Gap(24),
                CustomTextField1(
                  initialValue: _department.name,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'error_required_field'.tr(context);
                    }
                    return null;
                  },
                  keyboardType: TextInputType.name,
                  labelText: 'name'.tr(context),
                  hintText: 'department_name'.tr(context),
                  onValueChanged: (value) {
                    _department.name = value;
                  },
                  required: true,
                ),
                Gap(16),
                departmentsAsyncValue.when(
                  loading: () => const CircularProgressIndicator(),
                  error: (err, stack) => Text('Error: $err'),
                  data: (departments) => DepartmentChipsSelector(
                    title: "Selecteaza departamentele parinte",
                    departments: departments,
                    selectedDepartments: _department.parents,
                    onSelectionChanged: (updatedSelectedDepartments) {
                      setState(() {
                        _department.parents = updatedSelectedDepartments;
                      });
                    },
                  ),
                ),
                Gap(24),
                CustomToggle(
                  title: 'active'.tr(context),
                  subtitle: 'measurement_unit_activ_description'.tr(context),
                  initialValue: _department.flags == 1 ? true : false,
                  onChanged: (value) {
                    _department.flags = value ? 1 : 2;
                  },
                ),
                Gap(40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SecondaryButton(
                        text: 'close'.tr(context),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    const Gap(16),
                    Expanded(
                      child: PrimaryButton(
                        text: 'save'.tr(context),
                        onPressed: () async {
                          if (_itemUnitFormKey.currentState!.validate()) {
                            try {
                              await DepartmentService()
                                  .saveDepartment(department: _department);
                              ref
                                  .read(departmentsProvider.notifier)
                                  .refreshItemUnits();
                              Navigator.of(context).pop();
                              showToast(
                                _department.id == null
                                    ? 'suceess_add_department'.tr(context)
                                    : 'suceess_edit_department'.tr(context),
                                ToastType.success,
                              );
                            } catch (e) {
                              Navigator.of(context).pop();
                              showToast('error'.tr(context), ToastType.error);
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
