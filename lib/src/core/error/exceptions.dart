class ServerException implements Exception {
  final String message;
  final String? suggestion;

  ServerException({
    required this.message,
    this.suggestion,
  });

  @override
  String toString() {
    return 'ServerException: $message';
  }
}
