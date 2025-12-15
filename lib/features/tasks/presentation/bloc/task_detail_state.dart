import 'package:doido/features/tasks/domain/entities/task.dart';
import 'package:equatable/equatable.dart';

abstract class TaskDetailState extends Equatable {
  const TaskDetailState();
  @override
  List<Object?> get props => [];
}

class TaskDetailLoading extends TaskDetailState {}

class TaskDetailLoaded extends TaskDetailState {
  final Task task;
  const TaskDetailLoaded(this.task);

  @override
  List<Object?> get props => [task];
}

class TaskDetailFailure extends TaskDetailState {
  final String message;
  const TaskDetailFailure(this.message);

  @override
  List<Object?> get props => [message];
}
