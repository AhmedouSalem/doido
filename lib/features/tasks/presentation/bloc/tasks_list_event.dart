import 'package:doido/features/tasks/domain/entities/task.dart';
import 'package:equatable/equatable.dart';

abstract class TasksListEvent extends Equatable {
  const TasksListEvent();
  @override
  List<Object?> get props => [];
}

class TasksRequested extends TasksListEvent {
  const TasksRequested();
}

class TasksRefreshed extends TasksListEvent {
  const TasksRefreshed();
}

class TaskDeleteRequested extends TasksListEvent {
  final int id;
  const TaskDeleteRequested(this.id);

  @override
  List<Object?> get props => [id];
}

class TaskDismissed extends TasksListEvent {
  final Task task;
  const TaskDismissed(this.task);

  @override
  List<Object?> get props => [task];
}

class TaskUndoDeleteRequested extends TasksListEvent {
  final int taskId;
  const TaskUndoDeleteRequested(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class TaskMarkDoneRequested extends TasksListEvent {
  final int id;
  const TaskMarkDoneRequested(this.id);

  @override
  List<Object?> get props => [id];
}
