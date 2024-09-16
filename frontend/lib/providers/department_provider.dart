import 'package:erp_frontend_v2/models/department_model.dart';
import 'package:erp_frontend_v2/services/departments.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

// Item Units Provider

class DepartmentProvider extends StateNotifier<AsyncValue<List<Department>>> {
  DepartmentProvider() : super(const AsyncValue.loading()) {
    fetchDepartments(); // Optionally start fetching documents on initialization
  }

  Future<void> fetchDepartments() async {
    // state = const AsyncValue.loading();
    try {
      final departmentList = await DepartmentService().getDepartmentList();
      state = AsyncValue.data(departmentList);
    } catch (e) {
      //state = AsyncValue.error(e);
    }
  }

  void refreshItemUnits() {
    fetchDepartments();
  }
}

final departmentsProvider =
    StateNotifierProvider<DepartmentProvider, AsyncValue<List<Department>>>(
        (ref) {
  return DepartmentProvider();
});
