class BookAPIException implements Exception {
  final int statusCode;
  final String message;
  BookAPIException(this.statusCode, this.message);
}
