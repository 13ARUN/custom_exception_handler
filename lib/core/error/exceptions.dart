abstract class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => message;
}

class ServerException extends AppException {
  const ServerException([super.message = "Server error occurred"]);
}

class CacheException extends AppException {
  const CacheException([super.message = "Cache error occurred"]);
}

class TimeoutException extends AppException {
  const TimeoutException([super.message = "Request timeout"]);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = "Unauthorized request"]);
}

class UnknownException extends AppException {
  const UnknownException([super.message = "Unknown error occurred"]);
}

