import 'package:doido/core/errors/exceptions.dart';
import 'package:doido/features/tasks/data/db/app_database.dart';
import 'package:doido/features/tasks/data/models/task_model.dart';
import 'package:doido/features/tasks/domain/entities/task_status.dart';
import 'package:sqflite/sqflite.dart';

class TaskLocalDataSource {
  final AppDatabase _db;

  TaskLocalDataSource(this._db);

  Future<TaskModel> insert({
    required String title,
    String? description,
    required DateTime? dueDate,
    required int? timeStart,
    int? timeEnd,
    required TaskStatus status,
    required bool isReminder,
  }) async {
    final db = await _db.database;

    final id = await db.insert(
      TaskModel.table,
      {
        TaskModel.colTitle: title,
        TaskModel.colDescription: description,
        TaskModel.colDueDate: dueDate?.toIso8601String(),
        TaskModel.colTimeStart: timeStart,
        TaskModel.colTimeEnd: timeEnd,
        TaskModel.colStatus: _statusToString(status),
        TaskModel.colIsReminder: isReminder ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.abort,
    );

    final created = await getById(id);
    return created;
  }

  Future<List<TaskModel>> getAll() async {
    final db = await _db.database;

    final rows = await db.query(
      TaskModel.table,
      orderBy: '${TaskModel.colId} DESC',
    );

    return rows.map(TaskModel.fromMap).toList(growable: false);
  }

  Future<TaskModel> getById(int id) async {
    final db = await _db.database;

    final rows = await db.query(
      TaskModel.table,
      where: '${TaskModel.colId} = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (rows.isEmpty) {
      throw const NotFoundException("Tâche introuvable.");
    }

    return TaskModel.fromMap(rows.first);
  }

  Future<TaskModel> updateFields({
    required int id,
    String? title,
    String? description,
    DateTime? dueDate,
    int? timeStart,
    int? timeEnd,
    bool? isReminder,
  }) async {
    final db = await _db.database;

    // assure existence
    await getById(id);

    final values = <String, Object?>{};
    if (title != null) values[TaskModel.colTitle] = title;
    if (description != null) values[TaskModel.colDescription] = description;
    if (dueDate != null) {
      values[TaskModel.colDueDate] = dueDate.toIso8601String();
    }
    if (timeStart != null) values[TaskModel.colTimeStart] = timeStart;
    if (timeEnd != null) values[TaskModel.colTimeEnd] = timeEnd;
    if (isReminder != null) {
      values[TaskModel.colIsReminder] = isReminder ? 1 : 0;
    }
    if (values.isEmpty) {
      // rien à update => renvoyer l’état actuel
      return getById(id);
    }

    final count = await db.update(
      TaskModel.table,
      values,
      where: '${TaskModel.colId} = ?',
      whereArgs: [id],
    );

    if (count == 0) {
      throw const NotFoundException("Tâche introuvable.");
    }

    return getById(id);
  }

  Future<TaskModel> updateStatus({
    required int id,
    required TaskStatus status,
  }) async {
    final db = await _db.database;

    // assure existence
    await getById(id);

    final count = await db.update(
      TaskModel.table,
      {TaskModel.colStatus: _statusToString(status)},
      where: '${TaskModel.colId} = ?',
      whereArgs: [id],
    );

    if (count == 0) {
      throw const NotFoundException("Tâche introuvable.");
    }

    return getById(id);
  }

  Future<void> delete(int id) async {
    final db = await _db.database;

    // assure existence
    await getById(id);

    final count = await db.delete(
      TaskModel.table,
      where: '${TaskModel.colId} = ?',
      whereArgs: [id],
    );

    if (count == 0) {
      throw const NotFoundException("Tâche introuvable.");
    }
  }

  static String _statusToString(TaskStatus s) {
    switch (s) {
      case TaskStatus.pending:
        return 'PENDING';
      case TaskStatus.inProgress:
        return 'IN_PROGRESS';
      case TaskStatus.done:
        return 'DONE';
    }
  }
}
