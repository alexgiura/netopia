import 'dart:async';

import 'package:erp_frontend_v2/models/document/document_light_model.dart';
import 'package:erp_frontend_v2/models/document/document_model.dart';
import 'package:erp_frontend_v2/models/document/documents_filter_model.dart';
import 'package:erp_frontend_v2/models/partner/partner_model.dart';
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

// class DocumentProvider extends StateNotifier<AsyncValue<List<DocumentLight>>> {
//   DocumentProvider(DocumentFilter? externalFilter)
//       : _documentFilter = externalFilter ?? _lastUsedFilter ?? _internalFilter,
//         super(const AsyncValue.loading()) {
//     _lastUsedFilter = _documentFilter; // Store the used filter
//     fetchDocuments(); // Fetch documents on initialization
//   }
//   static final DocumentFilter _internalFilter = DocumentFilter.empty();
//   static DocumentFilter? _lastUsedFilter;
//   DocumentFilter _documentFilter;

//   //final DocumentFilter _documentFilter = DocumentFilter.empty();

//   Future<void> fetchDocuments() async {
//     state = const AsyncValue.loading();
//     try {
//       final documentList =
//           await DocumentService().getDocuments(documentFilter: _documentFilter);
//       state = AsyncValue.data(documentList);
//       print(documentList.first.isDeleted);
//     } catch (e) {

//       //state = AsyncValue.error(e);
//     }
//   }

//   void refreshDocuments() {
//     print(_documentFilter.startDate);
//     print(_documentFilter.endDate);
//     print(_documentFilter.partnerList?.first);
//     _documentFilter = _lastUsedFilter ?? _internalFilter;
//     fetchDocuments(); // This uses the current _documentFilter
//   }

//   void updateFilter(DocumentFilter newFilter) {
//     _documentFilter = newFilter;
//     // _documentFilter
//     //   ..documentTypeId = newFilter.documentTypeId
//     //   ..startDate = newFilter.startDate
//     //   ..endDate = newFilter.endDate
//     //   ..status = newFilter.status
//     //   ..partnerList = newFilter.partnerList;
//     fetchDocuments();
//   }
// }

class DocumentProvider extends StateNotifier<AsyncValue<List<DocumentLight>>> {
  DocumentProvider() : super(const AsyncValue.loading()) {
    fetchDocuments(); // Optionally start fetching documents on initialization
  }

  DocumentFilter _documentFilter = DocumentFilter.empty();

  Future<void> fetchDocuments() async {
    state = const AsyncValue.loading();
    try {
      final documentList =
          await DocumentService().getDocuments(documentFilter: _documentFilter);
      state = AsyncValue.data(documentList);
    } catch (e) {
      //state = AsyncValue.error(e);
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
    StateNotifierProvider<DocumentProvider, AsyncValue<List<DocumentLight>>>(
        (ref) {
  return DocumentProvider();
});
