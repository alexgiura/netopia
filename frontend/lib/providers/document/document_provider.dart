import 'dart:async';
import 'package:erp_frontend_v2/models/document/document_model.dart' as model;
import 'package:erp_frontend_v2/models/document/documents_filter_model.dart';
import 'package:erp_frontend_v2/services/document.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'document_provider.g.dart';

// Run: dart run build_runner watch

@riverpod
class DocumentNotifier extends _$DocumentNotifier {
  @override
  Future<List<model.Document>> build() async {
    return await fetchDocuments();
  }

  DocumentFilter _documentFilter = DocumentFilter.empty();

  Future<List<model.Document>> fetchDocuments() async {
    List<model.Document> documents =
        await DocumentService().getDocuments(documentFilter: _documentFilter);
    state = AsyncData(documents);
    return documents;
  }

  Future<void> refreshDocuments() async {
    fetchDocuments();
  }

  Future<void> updateFilter(DocumentFilter newFilter) async {
    _documentFilter = newFilter;
    fetchDocuments();
  }
}
