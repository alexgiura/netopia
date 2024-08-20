import 'package:erp_frontend_v2/models/document/currency_model.dart' as model;
import 'package:erp_frontend_v2/services/document.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'currency_provider.g.dart';

// Run: dart run build_runner watch

@riverpod
class CurrencyNotifier extends _$CurrencyNotifier {
  @override
  Future<List<model.Currency>> build() async {
    return await fetchCurrency();
  }

  Future<List<model.Currency>> fetchCurrency() async {
    final currencyList = await DocumentService().getCurrencyList();
    state = AsyncData(currencyList);
    return currencyList;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    try {
      final currencyList = await fetchCurrency();
      state = AsyncData(currencyList);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }
}
