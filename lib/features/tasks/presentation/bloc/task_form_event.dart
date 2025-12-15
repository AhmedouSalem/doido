import 'package:equatable/equatable.dart';

abstract class TaskFormEvent extends Equatable {
  const TaskFormEvent();
  @override
  List<Object?> get props => [];
}

class TaskCreateSubmitted extends TaskFormEvent {
  final String title;
  final String? description;

  final DateTime dueDate;
  final int timeStart;

  // Obligatoire si !isReminder
  final int? timeEnd;

  final bool isReminder;

  const TaskCreateSubmitted({
    required this.title,
    this.description,
    required this.dueDate,
    required this.timeStart,
    this.timeEnd,
    required this.isReminder,
  });

  @override
  List<Object?> get props => [
        title,
        description,
        dueDate,
        timeStart,
        timeEnd,
        isReminder,
      ];
}
