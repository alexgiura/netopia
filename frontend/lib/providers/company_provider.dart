import 'package:erp_frontend_v2/models/company/company_model.dart';
import 'package:erp_frontend_v2/services/company.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final companyProvider = FutureProvider<Company>((ref) async {
  final company = await CompanyService().getCompany();
  return company;
});
