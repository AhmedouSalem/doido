import 'package:doido/core/utils/validators.dart';
import 'package:equatable/equatable.dart';
import 'task_status.dart';

class Task extends Equatable {
  final int id;
  final String title;
  final String? description;
  final DateTime? dueDate;

  // time range (minutes since midnight)
  final int? timeStart;
  final int? timeEnd;

  final TaskStatus status;
  final bool isReminder;

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.dueDate,
    required this.timeStart,
    this.timeEnd,
    required this.status,
    required this.isReminder,
  }) {
    Validators.requireNonEmptyTitle(title);
    Validators.requireDueDate(dueDate);
    Validators.requireTimeStart(timeStart);
    Validators.validateStartEnd(
      timeStart: timeStart,
      timeEnd: timeEnd,
      isReminder: isReminder,
    );
  }

  Task copyWith({
    String? title,
    String? description,
    DateTime? dueDate,
    int? timeStart,
    int? timeEnd,
    TaskStatus? status,
    bool? isReminder,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      timeStart: timeStart ?? this.timeStart,
      timeEnd: timeEnd ?? this.timeEnd,
      status: status ?? this.status,
      isReminder: isReminder ?? this.isReminder,
    );
  }

  @override
  List<Object?> get props =>
      [id, title, description, dueDate, timeStart, timeEnd, status, isReminder];
}
