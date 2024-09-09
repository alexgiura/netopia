import 'package:erp_frontend_v2/constants/sizes.dart';
import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

import '../data/menu_data.dart';
import '../models/menu_model.dart';
import '../routing/router.dart';

final dropdownVisibilityProvider = StateProvider<bool>((ref) => false);
final filteredChildrenProvider =
    StateProvider<List<Map<String, dynamic>>>((ref) => []);

class CustomMenuSearchBar extends ConsumerStatefulWidget {
  const CustomMenuSearchBar({
    super.key,
    this.hintText,
    this.onValueChanged,
    this.initialValue,
    this.visibleBorder,
  });

  final String? hintText;
  final bool? visibleBorder;
  final String? initialValue;
  final Function(String)? onValueChanged;

  @override
  _CustomMenuSearchBarState createState() => _CustomMenuSearchBarState();
}

class _CustomMenuSearchBarState extends ConsumerState<CustomMenuSearchBar> {
  OverlayEntry? dropdown;
  final TextEditingController _controller = TextEditingController();

  void hideDropdown() {
    if (dropdown != null) {
      dropdown!.remove();
      dropdown = null;
      ref.read(dropdownVisibilityProvider.notifier).state = false;
    }
  }

  void showDropdown() {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    dropdown = OverlayEntry(
      builder: (context) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            hideDropdown();
          },
          child: Stack(
            children: [
              Positioned(
                top: position.dy + renderBox.size.height,
                left: position.dx,
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: renderBox.size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Consumer(
                      builder: (context, ref, _) {
                        final filteredChildren =
                            ref.watch(filteredChildrenProvider);
                        return filteredChildren.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('not_found_results'.tr(context)),
                              )
                            : Column(
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(
                                  filteredChildren.length,
                                  (index) {
                                    final child = filteredChildren[index];
                                    return ListTile(
                                      title: Text(child['title']),
                                      onTap: () {
                                        hideDropdown();
                                        List<String> route =
                                            generateRoute(Menu.fromJson(child));
                                        context.go(route[0]);
                                      },
                                    );
                                  },
                                ),
                              );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    overlay.insert(dropdown!);
  }

  void filterData(String query) {
    List<Map<String, dynamic>> allChildren = [];

    for (var parent in dataList) {
      if (parent['children'] != null) {
        for (var child in parent['children']) {
          allChildren.add(child);
        }
      }
    }
    if (query.isEmpty) {
      ref.read(filteredChildrenProvider.notifier).state = allChildren;
      return;
    }

    final filteredChildren = allChildren
        .where((child) =>
            child['title'].toLowerCase().contains(query.toLowerCase()))
        .toList();

    // update the reactive state of the filtered list
    ref.read(filteredChildrenProvider.notifier).state = filteredChildren;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: CustomStyle.regular14(color: CustomColor.slate_500),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: widget.visibleBorder == false
                ? Colors.transparent
                : CustomColor.slate_300,
            width: 1,
          ),
          borderRadius: CustomStyle.customBorderRadiusSmall,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: widget.visibleBorder == false
                ? Colors.transparent
                : CustomColor.textPrimary,
          ),
          borderRadius: CustomStyle.customBorderRadiusSmall,
        ),
        prefixIcon:
            const Icon(Icons.search_rounded, color: CustomColor.slate_700),
        hoverColor: Colors.transparent,
      ),
      style: CustomStyle.medium14(),
      onTap: () {
        filterData('');
      },
      onChanged: (value) {
        widget.onValueChanged?.call(value);
        filterData(value);
        if (dropdown == null) {
          showDropdown();
        }
      },
    );
  }
}
