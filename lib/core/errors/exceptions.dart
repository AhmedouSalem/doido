abstract class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => '$runtimeType: $message';
}

class ValidationException extends AppException {
  const ValidationException(super.message);
}

class NotFoundException extends AppException {
  const NotFoundException(super.message);
}

class StorageException extends AppException {
  const StorageException(super.message);
}
