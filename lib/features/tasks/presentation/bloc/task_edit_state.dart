import 'package:equatable/equatable.dart';
import '../../domain/entities/task.dart';

abstract class TaskEditState extends Equatable {
  const TaskEditState();
  @override
  List<Object?> get props => [];
}

class TaskEditLoading extends TaskEditState {
  const TaskEditLoading();
}

class TaskEditReady extends TaskEditState {
  final Task task;
  const TaskEditReady(this.task);

  @override
  List<Object?> get props => [task];
}

class TaskEditSubmitting extends TaskEditState {
  final Task task;
  const TaskEditSubmitting(this.task);

  @override
  List<Object?> get props => [task];
}

class TaskEditSuccess extends TaskEditState {
  const TaskEditSuccess();
}

class TaskEditFailure extends TaskEditState {
  final String message;
  const TaskEditFailure(this.message);

  @override
  List<Object?> get props => [message];
}
