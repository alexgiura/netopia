import 'package:erp_frontend_v2/models/document/document_transaction_model.dart';
import 'package:erp_frontend_v2/services/document.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// // Don't need async because FutureProvider takes care of that. So async could also be omitted
final documentTransactionProvider =
    FutureProvider<List<DocumentTransaction>>((ref) async {
  final documentTransactionsList =
      await DocumentService().getDocumentTransactions();
  return documentTransactionsList;
});
