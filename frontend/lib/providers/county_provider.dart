import 'package:erp_frontend_v2/models/county_model.dart';
import 'package:erp_frontend_v2/services/county.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_field/countries.dart';

class CountyProvider extends StateNotifier<AsyncValue<List<County>>> {
  CountyProvider() : super(const AsyncValue.loading()) {
    fetchCounties();
  }

  Future<void> fetchCounties() async {
    try {
      // Fetching countries from intl_phone_field package
      CountyService countyService = CountyService();
      List<County> countyList = await countyService.fetchCountyList();
      state = AsyncValue.data(countyList);
    } catch (e) {
      // state = AsyncValue.error(e);
    }
  }

  County? getCountyByCode(String code) {
    return state.when(
      data: (counties) {
        try {
          return counties.firstWhere((element) => element.code == code);
        } catch (e) {
          return null;
        }
      },
      loading: () => null,
      error: (error, stackTrace) => null,
    );
  }
}

final countyProvider =
    StateNotifierProvider<CountyProvider, AsyncValue<List<County>>>((ref) {
  return CountyProvider();
});
