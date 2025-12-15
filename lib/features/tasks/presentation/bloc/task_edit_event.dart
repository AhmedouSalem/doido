import 'package:equatable/equatable.dart';

abstract class TaskEditEvent extends Equatable {
  const TaskEditEvent();
  @override
  List<Object?> get props => [];
}

class TaskEditRequested extends TaskEditEvent {
  final int id;
  const TaskEditRequested(this.id);

  @override
  List<Object?> get props => [id];
}

class TaskEditSubmitted extends TaskEditEvent {
  final int id;

  final String? title;
  final String? description;

  final DateTime dueDate;
  final int timeStart;

  final int? timeEnd;

  final bool isReminder;

  const TaskEditSubmitted({
    required this.id,
    this.title,
    this.description,
    required this.dueDate,
    required this.timeStart,
    this.timeEnd,
    required this.isReminder,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        dueDate,
        timeStart,
        timeEnd,
        isReminder,
      ];
}
