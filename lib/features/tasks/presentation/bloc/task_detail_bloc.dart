import 'package:doido/core/errors/error_mapper.dart';
import 'package:doido/features/tasks/domain/usecases/complete_task.dart';
import 'package:doido/features/tasks/domain/usecases/get_task_by_id.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'task_detail_event.dart';
import 'task_detail_state.dart';

class TaskDetailBloc extends Bloc<TaskDetailEvent, TaskDetailState> {
  final GetTaskById getTaskById;
  final CompleteTask completeTask;

  TaskDetailBloc({
    required this.getTaskById,
    required this.completeTask,
  }) : super(TaskDetailLoading()) {
    on<TaskDetailRequested>(_onRequested);
    on<TaskMarkedDone>(_onMarkedDone);
  }

  Future<void> _onRequested(
    TaskDetailRequested event,
    Emitter<TaskDetailState> emit,
  ) async {
    emit(TaskDetailLoading());
    try {
      final task = await getTaskById(event.id);
      emit(TaskDetailLoaded(task));
    } catch (e) {
      emit(TaskDetailFailure(ErrorMapper.messageFrom(e)));
    }
  }

  Future<void> _onMarkedDone(
    TaskMarkedDone event,
    Emitter<TaskDetailState> emit,
  ) async {
    try {
      await completeTask(event.id);
      final updated = await getTaskById(event.id);
      emit(TaskDetailLoaded(updated));
    } catch (e) {
      emit(TaskDetailFailure(ErrorMapper.messageFrom(e)));
    }
  }
}
