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
    // state = const AsyncValue.loading();
    try {
      final user = await UserService().getUser(userId);
      state = AsyncValue.data(user);
    } catch (e) {
      // state = AsyncValue.error(e);
    }
  }

  void updateUserField(String field, dynamic value) {
    state.whenData((currentUser) {
      switch (field) {
        case 'id':
          state = AsyncValue.data(currentUser.copyWith(id: value as String));
          break;
        case 'email':
          state = AsyncValue.data(currentUser.copyWith(email: value as String));
          break;
        case 'phoneNumber':
          state = AsyncValue.data(
              currentUser.copyWith(phoneNumber: value as String));
          break;
        case 'company':
          state =
              AsyncValue.data(currentUser.copyWith(company: value as Company));
          break;
        case 'company.name':
          state = AsyncValue.data(
            currentUser.copyWith(
              company: currentUser.company?.copyWith(name: value as String),
            ),
          );
          break;
        case 'company.vat':
          state = AsyncValue.data(
            currentUser.copyWith(
              company: currentUser.company?.copyWith(vat: value as bool),
            ),
          );
          break;
        case 'company.vatNumber':
          state = AsyncValue.data(
            currentUser.copyWith(
              company:
                  currentUser.company?.copyWith(vatNumber: value as String),
            ),
          );
          break;
        case 'company.registrationNumber':
          state = AsyncValue.data(
            currentUser.copyWith(
              company: currentUser.company
                  ?.copyWith(registrationNumber: value as String),
            ),
          );
          break;
        case 'company.address.address':
          state = AsyncValue.data(
            currentUser.copyWith(
              company: currentUser.company?.copyWith(
                address: currentUser.company?.address
                    ?.copyWith(address: value as String),
              ),
            ),
          );
          break;
        case 'company.address.countyCode':
          state = AsyncValue.data(
            currentUser.copyWith(
              company: currentUser.company?.copyWith(
                address: currentUser.company?.address
                    ?.copyWith(countyCode: value as String),
              ),
            ),
          );
          break;
        case 'company.address.locality':
          state = AsyncValue.data(
            currentUser.copyWith(
              company: currentUser.company?.copyWith(
                address: currentUser.company?.address
                    ?.copyWith(locality: value as String),
              ),
            ),
          );
          break;
        default:
          throw ArgumentError('Field $field is not valid for User');
      }
    });
  }
}

final userProvider =
    StateNotifierProvider<UserProvider, AsyncValue<User>>((ref) {
  return UserProvider();
});
