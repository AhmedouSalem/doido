import 'package:equatable/equatable.dart';

abstract class TaskFormState extends Equatable {
  const TaskFormState();
  @override
  List<Object?> get props => [];
}

class TaskFormIdle extends TaskFormState {
  const TaskFormIdle();
}

class TaskFormSubmitting extends TaskFormState {
  const TaskFormSubmitting();
}

class TaskFormSuccess extends TaskFormState {
  const TaskFormSuccess();
}

class TaskFormFailure extends TaskFormState {
  final String message;
  const TaskFormFailure(this.message);

  @override
  List<Object?> get props => [message];
}
