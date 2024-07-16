import 'dart:async';
import 'package:erp_frontend_v2/models/document/document_model.dart';
import 'package:erp_frontend_v2/models/document/documents_filter_model.dart';
import 'package:erp_frontend_v2/services/document.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final documentByIdProvider =
    FutureProvider.family<Document, String>((ref, documentId) async {
  final document =
      await DocumentService().getDocumentById(documentId: documentId);
  return document;
});

final deleteDocumentProvider =
    FutureProvider.family<String, String>((ref, documentId) async {
  final result = await DocumentService()
      .deleteDocument(hId: documentId, deleteGenerated: false);
  return result;
});

class DocumentProvider extends StateNotifier<AsyncValue<List<Document>>> {
  DocumentProvider() : super(const AsyncValue.loading()) {
    fetchDocuments();
  }

  DocumentFilter _documentFilter = DocumentFilter.empty();

  Future<void> fetchDocuments() async {
    // state = const AsyncValue.loading();
    try {
      final documentList =
          await DocumentService().getDocuments(documentFilter: _documentFilter);
      state = AsyncValue.data(documentList);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  void refreshDocuments() {
    fetchDocuments();
  }

  void updateFilter(DocumentFilter newFilter) {
    _documentFilter = newFilter;
    fetchDocuments();
  }
}

final documentProvider =
    StateNotifierProvider<DocumentProvider, AsyncValue<List<Document>>>((ref) {
  return DocumentProvider();
});
