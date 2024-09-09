import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpansionNotifier extends StateNotifier<Map<int, bool>> {
  ExpansionNotifier() : super({});

  void toggleExpanded(int index) {
    // Schimbă starea de expansiune pentru elementul curent
    state = {
      ...state,
      index: !(state[index] ?? false),
    };
  }

  void collapseAll() {
    // Resetează toate stările la false
    state = {};
  }
}

final expansionProvider =
    StateNotifierProvider<ExpansionNotifier, Map<int, bool>>((ref) {
  return ExpansionNotifier();
});
