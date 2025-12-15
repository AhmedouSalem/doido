import 'dart:async';
import 'package:doido/core/errors/error_mapper.dart';
import 'package:doido/features/tasks/domain/entities/task.dart';
import 'package:doido/features/tasks/domain/entities/task_status.dart';
import 'package:doido/features/tasks/domain/usecases/complete_task.dart';
import 'package:doido/features/tasks/domain/usecases/delete_task.dart';
import 'package:doido/features/tasks/domain/usecases/get_tasks.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'tasks_list_event.dart';
import 'tasks_list_state.dart';

class TasksListBloc extends Bloc<TasksListEvent, TasksListState> {
  final GetTasks getTasks;
  final DeleteTask deleteTask;
  final CompleteTask completeTask;

  final Map<int, Timer> _pendingDeleteTimers = {};
  final Map<int, Task> _pendingDeletedTasks = {};

  TasksListBloc({
    required this.getTasks,
    required this.deleteTask,
    required this.completeTask,
  }) : super(const TasksListInitial()) {
    on<TasksRequested>(_onRequested);
    on<TasksRefreshed>(_onRefreshed);
    on<TaskDismissed>(_onDismissed);
    on<TaskUndoDeleteRequested>(_onUndoDelete);
    on<TaskMarkDoneRequested>(_onMarkDone);
  }

  Future<void> _onRequested(
      TasksRequested event, Emitter<TasksListState> emit) async {
    emit(const TasksListLoading());
    try {
      final tasks = await getTasks();
      emit(TasksListLoaded(tasks));
    } catch (e) {
      emit(TasksListFailure(ErrorMapper.messageFrom(e)));
    }
  }

  Future<void> _onRefreshed(
      TasksRefreshed event, Emitter<TasksListState> emit) async {
    try {
      final tasks = await getTasks();
      emit(TasksListLoaded(tasks));
    } catch (e) {
      emit(TasksListFailure(ErrorMapper.messageFrom(e)));
    }
  }

  Future<void> _onDismissed(
      TaskDismissed event, Emitter<TasksListState> emit) async {
    final current = state;
    if (current is! TasksListLoaded) return;

    final task = event.task;

    // retire de la liste immédiatement
    emit(TasksListLoaded(current.tasks.where((t) => t.id != task.id).toList()));

    // planifie la suppression dans 4s, pour permettre Undo
    _pendingDeletedTasks[task.id] = task;
    _pendingDeleteTimers[task.id]?.cancel();
    _pendingDeleteTimers[task.id] = Timer(const Duration(seconds: 4), () async {
      try {
        await deleteTask(task.id);
      } catch (_) {
        // si delete échoue : on laisse la prochaine refresh corriger l’état
      } finally {
        _pendingDeletedTasks.remove(task.id);
        _pendingDeleteTimers.remove(task.id);
      }
    });
  }

  Future<void> _onUndoDelete(
      TaskUndoDeleteRequested event, Emitter<TasksListState> emit) async {
    final current = state;
    if (current is! TasksListLoaded) return;

    final task = _pendingDeletedTasks[event.taskId];
    if (task == null) return;

    _pendingDeleteTimers[event.taskId]?.cancel();
    _pendingDeleteTimers.remove(event.taskId);
    _pendingDeletedTasks.remove(event.taskId);

    // restore (en haut)
    emit(TasksListLoaded([task, ...current.tasks]));
  }

  Future<void> _onMarkDone(
      TaskMarkDoneRequested event, Emitter<TasksListState> emit) async {
    final current = state;
    if (current is! TasksListLoaded) return;

    // optimistic UI
    final updatedList = current.tasks.map((t) {
      if (t.id == event.id) return t.copyWith(status: TaskStatus.done);
      return t;
    }).toList();
    emit(TasksListLoaded(updatedList));

    try {
      await completeTask(event.id);
    } catch (e) {
      emit(current); // rollback
      emit(TasksListFailure(ErrorMapper.messageFrom(e)));
    }
  }

  @override
  Future<void> close() {
    for (final t in _pendingDeleteTimers.values) {
      t.cancel();
    }
    _pendingDeleteTimers.clear();
    _pendingDeletedTasks.clear();
    return super.close();
  }
}
