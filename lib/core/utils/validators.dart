import 'package:doido/core/errors/exceptions.dart';

class Validators {
  static void requireNonEmptyTitle(String title) {
    if (title.trim().isEmpty) {
      throw const ValidationException("Le titre est requis.");
    }
  }

  static void requireDueDate(DateTime? dueDate) {
    if (dueDate == null) {
      throw const ValidationException("La date est requise.");
    }
  }

  static void requireTimeStart(int? timeStart) {
    if (timeStart == null) {
      throw const ValidationException("L'heure de début est requise.");
    }
  }

  /// minutes in [0..1439]
  static void validateTimeMinutes(int minutes) {
    if (minutes < 0 || minutes > 1439) {
      throw const ValidationException(
          "Heure invalide (minutes depuis minuit).");
    }
  }

  static void validateStartEnd({
    required int? timeStart,
    required int? timeEnd,
    required bool isReminder,
  }) {
    if (timeStart != null) validateTimeMinutes(timeStart);
    if (timeEnd != null) validateTimeMinutes(timeEnd);

    if (!isReminder && timeEnd == null) {
      throw const ValidationException(
          "L'heure de fin est requise (hors rappel).");
    }

    if (timeStart != null && timeEnd != null && timeEnd < timeStart) {
      throw const ValidationException(
          "L'heure de fin doit être >= à l'heure de début.");
    }
  }
}
