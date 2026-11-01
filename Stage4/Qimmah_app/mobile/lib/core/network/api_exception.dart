// الخطأ اللي يرجعه السيرفر: { "error": "..." }
class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException(this.message, this.statusCode);
}
