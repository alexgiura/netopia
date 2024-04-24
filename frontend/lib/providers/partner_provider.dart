import 'package:erp_frontend_v2/services/partner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/partner/partner_model.dart';
import '../models/partner/partner_filter_model.dart';

// final partnerProvider = FutureProvider<List<Partner>>((ref) async {
//   PartnerFilter partnerFilter = PartnerFilter.empty();
//   final partners =
//       await PartnerService().getPartners(partnerFilter: partnerFilter);
//   return partners;
// });

class PartnerProvider extends StateNotifier<AsyncValue<List<Partner>>> {
  PartnerProvider() : super(const AsyncValue.loading()) {
    fetchPartners();
  }

  PartnerFilter partnerFilter = PartnerFilter.empty();

  Future<void> fetchPartners() async {
    // state = const AsyncValue.loading();
    try {
      final partnerList =
          await PartnerService().getPartners(partnerFilter: partnerFilter);
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
