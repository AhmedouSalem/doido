import 'exceptions.dart';

class ErrorMapper {
  static String messageFrom(Object error) {
    if (error is AppException) return error.message;
    return "Une erreur est survenue.";
  }
}
