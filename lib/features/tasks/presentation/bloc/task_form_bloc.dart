import 'package:doido/core/errors/error_mapper.dart';
import 'package:doido/features/tasks/domain/usecases/create_task.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'task_form_event.dart';
import 'task_form_state.dart';

class TaskFormBloc extends Bloc<TaskFormEvent, TaskFormState> {
  final CreateTask createTask;

  TaskFormBloc({required this.createTask}) : super(const TaskFormIdle()) {
    on<TaskCreateSubmitted>(_onCreateSubmitted);
  }

  Future<void> _onCreateSubmitted(
    TaskCreateSubmitted event,
    Emitter<TaskFormState> emit,
  ) async {
    emit(const TaskFormSubmitting());
    try {
      await createTask(
        CreateTaskParams(
          title: event.title,
          description: event.description,
          dueDate: event.dueDate,
          timeStart: event.timeStart,
          timeEnd: event.timeEnd,
          isReminder: event.isReminder,
        ),
      );
      emit(const TaskFormSuccess());
    } catch (e) {
      emit(TaskFormFailure(ErrorMapper.messageFrom(e)));
    }
  }
}
