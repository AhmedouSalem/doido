import 'package:doido/core/errors/exceptions.dart';
import 'package:doido/core/utils/validators.dart';
import 'package:doido/features/tasks/data/datasources/task_local_datasource.dart';
import 'package:doido/features/tasks/domain/entities/task.dart';
import 'package:doido/features/tasks/domain/entities/task_status.dart';
import 'package:doido/features/tasks/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource local;

  TaskRepositoryImpl(this.local);

  @override
  Future<Task> create({
    required String title,
    String? description,
    required DateTime? dueDate,
    required int? timeStart,
    int? timeEnd,
    required bool isReminder,
  }) async {
    Validators.requireNonEmptyTitle(title);
    Validators.requireDueDate(dueDate);
    Validators.requireTimeStart(timeStart);
    Validators.validateStartEnd(
      timeStart: timeStart,
      timeEnd: timeEnd,
      isReminder: isReminder,
    );

    try {
      final model = await local.insert(
        title: title.trim(),
        description: description,
        dueDate: dueDate,
        timeStart: timeStart,
        timeEnd: timeEnd,
        isReminder: isReminder,
        status: TaskStatus.pending, // règle métier
      );
      return model.toEntity();
    } on AppException {
      rethrow;
    } catch (e) {
      throw StorageException("Erreur stockage (create): $e");
    }
  }

  @override
  Future<List<Task>> getAll() async {
    try {
      final rows = await local.getAll();
      return rows.map((m) => m.toEntity()).toList(growable: false);
    } catch (e) {
      throw StorageException("Erreur stockage (getAll): $e");
    }
  }

  @override
  Future<Task> getById(int id) async {
    try {
      final model = await local.getById(id);
      return model.toEntity();
    } on AppException {
      rethrow;
    } catch (e) {
      throw StorageException("Erreur stockage (getById): $e");
    }
  }

  @override
  Future<Task> update({
    required int id,
    String? title,
    String? description,
    required DateTime? dueDate,
    required int? timeStart,
    int? timeEnd,
    required bool isReminder,
  }) async {
    if (title != null) Validators.requireNonEmptyTitle(title);
    Validators.requireDueDate(dueDate);
    Validators.requireTimeStart(timeStart);
    Validators.validateStartEnd(
      timeStart: timeStart,
      timeEnd: timeEnd,
      isReminder: isReminder,
    );

    try {
      final model = await local.updateFields(
        id: id,
        title: title?.trim(),
        description: description,
        dueDate: dueDate,
        timeStart: timeStart,
        timeEnd: timeEnd,
        isReminder: isReminder,
      );
      return model.toEntity();
    } on AppException {
      rethrow;
    } catch (e) {
      throw StorageException("Erreur stockage (update): $e");
    }
  }

  @override
  Future<Task> updateStatus(
      {required int id, required TaskStatus status}) async {
    try {
      final model = await local.updateStatus(id: id, status: status);
      return model.toEntity();
    } on AppException {
      rethrow;
    } catch (e) {
      throw StorageException("Erreur stockage (updateStatus): $e");
    }
  }

  @override
  Future<void> delete(int id) async {
    try {
      await local.delete(id);
    } on AppException {
      rethrow;
    } catch (e) {
      throw StorageException("Erreur stockage (delete): $e");
    }
  }
}
