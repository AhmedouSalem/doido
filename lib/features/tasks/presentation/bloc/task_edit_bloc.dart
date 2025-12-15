import 'package:doido/core/errors/error_mapper.dart';
import 'package:doido/features/tasks/domain/usecases/get_task_by_id.dart';
import 'package:doido/features/tasks/domain/usecases/update_task.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'task_edit_event.dart';
import 'task_edit_state.dart';

class TaskEditBloc extends Bloc<TaskEditEvent, TaskEditState> {
  final GetTaskById getTaskById;
  final UpdateTask updateTask;

  TaskEditBloc({
    required this.getTaskById,
    required this.updateTask,
  }) : super(const TaskEditLoading()) {
    on<TaskEditRequested>(_onRequested);
    on<TaskEditSubmitted>(_onSubmitted);
  }

  Future<void> _onRequested(
    TaskEditRequested event,
    Emitter<TaskEditState> emit,
  ) async {
    emit(const TaskEditLoading());
    try {
      final task = await getTaskById(event.id);
      emit(TaskEditReady(task));
    } catch (e) {
      emit(TaskEditFailure(ErrorMapper.messageFrom(e)));
    }
  }

  Future<void> _onSubmitted(
    TaskEditSubmitted event,
    Emitter<TaskEditState> emit,
  ) async {
    final current = state;
    if (current is TaskEditReady) {
      emit(TaskEditSubmitting(current.task));
    } else if (current is TaskEditSubmitting) {
      return; // évite double submit
    }

    try {
      await updateTask(
        UpdateTaskParams(
          id: event.id,
          title: event.title,
          description: event.description,
          dueDate: event.dueDate,
          timeStart: event.timeStart,
          timeEnd: event.timeEnd,
          isReminder: event.isReminder,
        ),
      );
      emit(const TaskEditSuccess());
    } catch (e) {
      emit(TaskEditFailure(ErrorMapper.messageFrom(e)));
    }
  }
}
