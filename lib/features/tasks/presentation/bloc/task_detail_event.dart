import 'package:equatable/equatable.dart';

abstract class TaskDetailEvent extends Equatable {
  const TaskDetailEvent();
  @override
  List<Object?> get props => [];
}

class TaskDetailRequested extends TaskDetailEvent {
  final int id;
  const TaskDetailRequested(this.id);

  @override
  List<Object?> get props => [id];
}

class TaskMarkedDone extends TaskDetailEvent {
  final int id;
  const TaskMarkedDone(this.id);

  @override
  List<Object?> get props => [id];
}
