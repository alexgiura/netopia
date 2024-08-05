import 'package:erp_frontend_v2/models/company/company_model.dart';
import 'package:erp_frontend_v2/models/user/user.dart';
import 'package:erp_frontend_v2/services/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProvider extends StateNotifier<AsyncValue<User>> {
  UserProvider() : super(const AsyncValue.loading()) {
    User.empty();
  }

  void updateUser(User newUser) {
    state = AsyncValue.data(newUser);
  }

  Future<void> getUserById(String userId) async {
    state = const AsyncValue.loading();
    try {
      final user = await UserService().getUser(userId);
      state = AsyncValue.data(user);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

final userProvider =
    StateNotifierProvider<UserProvider, AsyncValue<User>>((ref) {
  return UserProvider();
});
