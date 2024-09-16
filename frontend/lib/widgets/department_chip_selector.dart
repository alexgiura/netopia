import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/models/department_model.dart';
import 'package:flutter/material.dart';

class DepartmentChipsSelector extends StatefulWidget {
  final String title;
  final List<Department> departments;
  final List<Department> selectedDepartments;
  final ValueChanged<List<Department>> onSelectionChanged;

  const DepartmentChipsSelector({
    Key? key,
    required this.title,
    required this.departments,
    required this.selectedDepartments,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  _DepartmentChipsSelectorState createState() =>
      _DepartmentChipsSelectorState();
}

class _DepartmentChipsSelectorState extends State<DepartmentChipsSelector> {
  late List<Department> _selectedDepartments;

  @override
  void initState() {
    super.initState();
    _selectedDepartments =
        List.from(widget.selectedDepartments); // Clone the selected list
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          widget.title,
          style: CustomStyle.regular16(),
        ),
        const SizedBox(height: 8),

        // List of Chips
        Wrap(
          runSpacing: 8.0,
          spacing: 8.0,
          children: widget.departments.map((department) {
            // Check if this department is selected
            final isSelected = _selectedDepartments
                .any((selected) => selected.id == department.id);

            return FilterChip(
              label: Text(department.name),
              selected: isSelected,
              onSelected: (bool selected) {
                setState(() {
                  if (selected) {
                    // Add to selected list
                    _selectedDepartments.add(department);
                  } else {
                    // Remove from selected list
                    _selectedDepartments.removeWhere(
                        (selected) => selected.id == department.id);
                  }
                  // Trigger the callback with updated selected departments
                  widget.onSelectionChanged(_selectedDepartments);
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
