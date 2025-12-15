import 'package:doido/features/tasks/domain/entities/task.dart';
import 'package:doido/features/tasks/domain/entities/task_status.dart';

class TaskModel {
  static const table = 'tasks';

  static const colId = 'id';
  static const colTitle = 'title';
  static const colDescription = 'description';
  static const colDueDate = 'due_date';
  static const colTimeStart = 'time_start';
  static const colTimeEnd = 'time_end';
  static const colStatus = 'status';
  static const colIsReminder = 'is_reminder';

  final int id;
  final String title;
  final String? description;
  final DateTime? dueDate;
  final int? timeStart;
  final int? timeEnd;
  final TaskStatus status;
  final bool isReminder;

  const TaskModel({
    required this.id,
    required this.title,
    this.description,
    this.dueDate,
    this.timeStart,
    this.timeEnd,
    required this.status,
    required this.isReminder,
  });

  factory TaskModel.fromMap(Map<String, Object?> map) {
    return TaskModel(
      id: (map[colId] as int),
      title: (map[colTitle] as String),
      description: map[colDescription] as String?,
      dueDate: (map[colDueDate] as String?) == null
          ? null
          : DateTime.parse(map[colDueDate] as String),
      timeStart: map[colTimeStart] as int?,
      timeEnd: map[colTimeEnd] as int?,
      status: _statusFromString(map[colStatus] as String),
      isReminder: (map[colIsReminder] as int) == 1,
    );
  }

  Map<String, Object?> toMap() {
    return {
      colId: id,
      colTitle: title,
      colDescription: description,
      colDueDate: dueDate?.toIso8601String(),
      colTimeStart: timeStart,
      colTimeEnd: timeEnd,
      colStatus: _statusToString(status),
      colIsReminder: isReminder ? 1 : 0,
    };
  }

  Task toEntity() {
    return Task(
      id: id,
      title: title,
      description: description,
      dueDate: dueDate,
      timeStart: timeStart,
      timeEnd: timeEnd,
      status: status,
      isReminder: isReminder,
    );
  }

  factory TaskModel.fromEntity(Task t) {
    return TaskModel(
      id: t.id,
      title: t.title,
      description: t.description,
      dueDate: t.dueDate,
      timeStart: t.timeStart,
      timeEnd: t.timeEnd,
      status: t.status,
      isReminder: t.isReminder,
    );
  }

  static TaskStatus _statusFromString(String raw) {
    switch (raw) {
      case 'PENDING':
        return TaskStatus.pending;
      case 'IN_PROGRESS':
        return TaskStatus.inProgress;
      case 'DONE':
        return TaskStatus.done;
      default:
        // fallback safe
        return TaskStatus.pending;
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
