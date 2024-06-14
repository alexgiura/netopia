import 'package:erp_frontend_v2/models/company/company_model.dart';
import 'package:erp_frontend_v2/models/user/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserNotifier extends StateNotifier<User> {
  UserNotifier() : super(User.empty());

  void updateUser(User newUser) {
    state = newUser;
  }

  void updateUserField(String field, dynamic value) {
    switch (field) {
      case 'id':
        state = state.copyWith(id: value as String);
        break;
      case 'email':
        state = state.copyWith(email: value as String);
        break;
      case 'phoneNumber':
        state = state.copyWith(phoneNumber: value as String);
        break;
      case 'company':
        state = state.copyWith(company: value as Company);
        break;
      case 'company.name':
        state = state.copyWith(
          company: state.company?.copyWith(name: value as String),
        );
        break;
      case 'company.vat':
        state = state.copyWith(
          company: state.company?.copyWith(vat: value as bool),
        );
        break;
      case 'company.vatNumber':
        state = state.copyWith(
          company: state.company?.copyWith(vatNumber: value as String),
        );
        break;
      case 'company.registrationNumber':
        state = state.copyWith(
          company: state.company?.copyWith(registrationNumber: value as String),
        );
        break;
      case 'company.address.address':
        state = state.copyWith(
          company: state.company?.copyWith(
            address: state.company?.address?.copyWith(address: value as String),
          ),
        );
        break;
      case 'company.address.countyCode':
        state = state.copyWith(
          company: state.company?.copyWith(
            address:
                state.company?.address?.copyWith(countyCode: value as String),
          ),
        );
        break;
      case 'company.address.locality':
        state = state.copyWith(
          company: state.company?.copyWith(
            address:
                state.company?.address?.copyWith(locality: value as String),
          ),
        );
        break;

      default:
        throw ArgumentError('Field $field is not valid for User');
    }
  }
}

final userProvider = StateNotifierProvider<UserNotifier, User>(
  (ref) => UserNotifier(),
);
