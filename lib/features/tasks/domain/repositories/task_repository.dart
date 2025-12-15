import 'package:doido/features/tasks/domain/entities/task.dart';
import 'package:doido/features/tasks/domain/entities/task_status.dart';

abstract class TaskRepository {
  Future<Task> create({
    required String title,
    String? description,
    required DateTime? dueDate,
    required int? timeStart,
    int? timeEnd,
    required bool isReminder,
  });

  Future<List<Task>> getAll();

  Future<Task> getById(int id);

  /// Update title/description/dueDate/timeStart/timeEnd only (status unchanged)
  Future<Task> update({
    required int id,
    String? title,
    String? description,
    required DateTime? dueDate,
    required int? timeStart,
    int? timeEnd,
    required bool isReminder,
  });

  Future<Task> updateStatus({
    required int id,
    required TaskStatus status,
  });

  Future<void> delete(int id);
}
