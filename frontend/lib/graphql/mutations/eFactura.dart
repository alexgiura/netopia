const String generateEfacturaAuthorizationLink = r'''
mutation generateEfacturaAuthorizationLink {
  generateEfacturaAuthorizationLink
}
''';

const String uploadEfacturaDocument = r'''
mutation uploadEfacturaDocument($input: GenerateEfacturaDocumentInput!) {
    uploadEfacturaDocument(input: $input)
}
''';
