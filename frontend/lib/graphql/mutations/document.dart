const String saveDocument = r'''
mutation saveDocument($input: DocumentInput!) {
  saveDocument(input: $input) 
}
''';

const String deleteDocument = r'''
mutation deleteDocument($input: DeleteDocumentInput!) {
  deleteDocument(input: $input) 
}
''';
