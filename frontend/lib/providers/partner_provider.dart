import 'package:erp_frontend_v2/models/partner/partner_type_model.dart';
import 'package:erp_frontend_v2/services/partner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/partner/partner_model.dart';
import '../models/partner/partner_filter_model.dart';

class PartnerProvider extends StateNotifier<AsyncValue<List<Partner>>> {
  PartnerProvider() : super(const AsyncValue.loading()) {
    fetchPartners();
  }

  PartnerFilter partnerFilter = PartnerFilter.empty();

  Future<void> fetchPartners() async {
    // state = const AsyncValue.loading();
    try {
      final partnerList = await PartnerService().getPartners();
      state = AsyncValue.data(partnerList);
    } catch (e) {
      //state = AsyncValue.error(e);
    }
  }

  void refreshPartners() {
    fetchPartners();
  }

  void updateFilter(PartnerFilter newFilter) {
    partnerFilter = newFilter;
    fetchPartners();
  }
}

final partnerProvider =
    StateNotifierProvider<PartnerProvider, AsyncValue<List<Partner>>>((ref) {
  return PartnerProvider();
});

class PartnerTypeProvider extends StateNotifier<AsyncValue<List<PartnerType>>> {
  PartnerTypeProvider() : super(const AsyncValue.loading()) {
    fetchPartnerTypes();
  }

  void fetchPartnerTypes() {
    // Simulate fetching data
    state = AsyncValue.data(PartnerType.partnerTypes);
  }

  void refreshPartnerTypes() {
    fetchPartnerTypes();
  }
}

final partnerTypeProvider =
    StateNotifierProvider<PartnerTypeProvider, AsyncValue<List<PartnerType>>>(
  (ref) => PartnerTypeProvider(),
);
