abstract class AppException implements Exception {
  final String message;
  final String? code;

  AppException(this.message, {this.code});

  @override
  String toString() => message;
}

class AuthException extends AppException {
  AuthException(super.message, {super.code});
}

class NetworkException extends AppException {
  NetworkException(super.message, {super.code});
}

class ServerException extends AppException {
  final int? statusCode;

  ServerException(super.message, {super.code, this.statusCode});
}

class ValidationException extends AppException {
  ValidationException(super.message, {super.code});
}

class CacheException extends AppException {
  CacheException(super.message, {super.code});
}

class UnknownException extends AppException {
  UnknownException(super.message, {super.code});
}
