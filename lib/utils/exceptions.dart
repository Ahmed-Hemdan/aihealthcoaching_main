class AuthException implements Exception {
  final String code;
  final String message;

  AuthException(this.code, this.message);
}

class ApiException implements Exception {
  final String code;
  final String message;
  ApiException(this.code, this.message);
}

String removeAllHtmlTags(String htmlText) {
  RegExp exp = RegExp(
      r"<[^>]*>",
      multiLine: true,
      caseSensitive: true
  );

  return htmlText.replaceAll(exp, '');
}