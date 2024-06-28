import 'package:erp_frontend_v2/models/item/item_category_model.dart';
import 'package:erp_frontend_v2/models/item/item_filter_model.dart';
import 'package:erp_frontend_v2/models/item/item_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/item/um_model.dart';
import '../models/item/vat_model.dart';
import '../services/item.dart';

final itemsProvider = FutureProvider<List<Item>>((ref) async {
  ItemFilter itemFilter = ItemFilter.empty();
  final items = await ItemService().getItems(itemFilter: itemFilter);
  return items;
});

final umProvider = FutureProvider<List<Um>>((ref) async {
  final umList = await ItemService().getUmList();
  return umList;
});

final vatProvider = FutureProvider<List<Vat>>((ref) async {
  final vatList = await ItemService().getVatList();
  return vatList;
});

// Item Provider

class ItemProvider extends StateNotifier<AsyncValue<List<Item>>> {
  ItemProvider() : super(const AsyncValue.loading()) {
    fetchItems(); // Optionally start fetching documents on initialization
  }

  ItemFilter itemFilter = ItemFilter.empty();

  Future<void> fetchItems() async {
    try {
      final itemList = await ItemService().getItems(itemFilter: itemFilter);
      state = AsyncValue.data(itemList);
    } catch (e) {
      //state = AsyncValue.error(e);
    }
  }

  void refreshItems() {
    fetchItems();
  }

  void updateFilter(ItemFilter newFilter) {
    itemFilter = newFilter;
    fetchItems();
  }
}

final itemProvider =
    StateNotifierProvider<ItemProvider, AsyncValue<List<Item>>>((ref) {
  return ItemProvider();
});

// Item Category Provider

class ItemCategoryProvider
    extends StateNotifier<AsyncValue<List<ItemCategory>>> {
  ItemCategoryProvider() : super(const AsyncValue.loading()) {
    fetchItemCategories(); // Optionally start fetching documents on initialization
  }

  ItemFilter itemFilter = ItemFilter.empty();

  Future<void> fetchItemCategories() async {
    state = const AsyncValue.loading();
    try {
      final itemCategoryList = await ItemService().getItemCategoryList();
      state = AsyncValue.data(itemCategoryList);
    } catch (e) {
      //state = AsyncValue.error(e);
    }
  }

  void refreshItemCategories() {
    fetchItemCategories();
  }
}

final itemCategoryProvider =
    StateNotifierProvider<ItemCategoryProvider, AsyncValue<List<ItemCategory>>>(
        (ref) {
  return ItemCategoryProvider();
});

// Item Units Provider

class ItemUnitsProvider extends StateNotifier<AsyncValue<List<Um>>> {
  ItemUnitsProvider() : super(const AsyncValue.loading()) {
    fetchItemUnits(); // Optionally start fetching documents on initialization
  }

  Future<void> fetchItemUnits() async {
    state = const AsyncValue.loading();
    try {
      final itemUnitsList = await ItemService().getUmList();
      state = AsyncValue.data(itemUnitsList);
    } catch (e) {
      //state = AsyncValue.error(e);
    }
  }

  void refreshItemUnits() {
    fetchItemUnits();
  }
}

final itemUnitsProvider =
    StateNotifierProvider<ItemUnitsProvider, AsyncValue<List<Um>>>((ref) {
  return ItemUnitsProvider();
});
