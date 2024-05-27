import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_field/countries.dart';

class CountryProvider extends StateNotifier<AsyncValue<List<Country>>> {
  CountryProvider() : super(const AsyncValue.loading()) {
    fetchCountries();
  }

  Future<void> fetchCountries() async {
    try {
      // Fetching countries from intl_phone_field package
      const countryList = countries;
      state = const AsyncValue.data(countryList);
    } catch (e) {
      //state = AsyncValue.error(e);
    }
  }
}

final countryProvider =
    StateNotifierProvider<CountryProvider, AsyncValue<List<Country>>>((ref) {
  return CountryProvider();
});
