import 'package:doido/features/tasks/domain/entities/task.dart';
import 'package:equatable/equatable.dart';

abstract class TasksListState extends Equatable {
  const TasksListState();
  @override
  List<Object?> get props => [];
}

class TasksListInitial extends TasksListState {
  const TasksListInitial();
}

class TasksListLoading extends TasksListState {
  const TasksListLoading();
}

class TasksListLoaded extends TasksListState {
  final List<Task> tasks;
  const TasksListLoaded(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

class TasksListFailure extends TasksListState {
  final String message;
  const TasksListFailure(this.message);

  @override
  List<Object?> get props => [message];
}
