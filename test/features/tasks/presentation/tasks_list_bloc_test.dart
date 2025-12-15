import 'package:bloc_test/bloc_test.dart';
import 'package:doido/features/tasks/domain/usecases/complete_task.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:doido/features/tasks/domain/entities/task.dart';
import 'package:doido/features/tasks/domain/entities/task_status.dart';
import 'package:doido/features/tasks/domain/usecases/delete_task.dart';
import 'package:doido/features/tasks/domain/usecases/get_tasks.dart';
import 'package:doido/features/tasks/presentation/bloc/tasks_list_bloc.dart';
import 'package:doido/features/tasks/presentation/bloc/tasks_list_event.dart';
import 'package:doido/features/tasks/presentation/bloc/tasks_list_state.dart';

class MockGetTasks extends Mock implements GetTasks {}

class MockDeleteTask extends Mock implements DeleteTask {}

class MockCompleteTask extends Mock implements CompleteTask {}

void main() {
  late MockGetTasks getTasks;
  late MockDeleteTask deleteTask;
  late MockCompleteTask completeTask;

  setUp(() {
    getTasks = MockGetTasks();
    deleteTask = MockDeleteTask();
    completeTask = MockCompleteTask();
  });

  blocTest<TasksListBloc, TasksListState>(
    'TasksRequested -> Loading -> Loaded',
    build: () {
      when(() => getTasks()).thenAnswer((_) async => [
            Task(
              id: 1,
              title: 'A',
              status: TaskStatus.pending,
              description: null,
              dueDate: DateTime(2025, 1, 1),
              timeStart: 9 * 60,
              timeEnd: 9 * 60 + 30,
              isReminder: false,
            ),
          ]);
      return TasksListBloc(
          getTasks: getTasks,
          deleteTask: deleteTask,
          completeTask: completeTask);
    },
    act: (bloc) => bloc.add(const TasksRequested()),
    expect: () => [
      const TasksListLoading(),
      isA<TasksListLoaded>().having((s) => s.tasks.length, 'len', 1),
    ],
  );

  blocTest<TasksListBloc, TasksListState>(
    'TaskDismissed -> removes task from list (optimistic)',
    build: () {
      when(() => deleteTask(any())).thenAnswer((_) async {});
      return TasksListBloc(
          getTasks: getTasks,
          deleteTask: deleteTask,
          completeTask: completeTask);
    },
    seed: () => TasksListLoaded([
      Task(
        id: 1,
        title: 'A',
        status: TaskStatus.pending,
        description: null,
        dueDate: DateTime(2025, 1, 1),
        timeStart: 9 * 60,
        timeEnd: 9 * 60 + 30,
        isReminder: false,
      ),
      Task(
        id: 2,
        title: 'B',
        status: TaskStatus.pending,
        description: null,
        dueDate: DateTime(2025, 1, 1),
        timeStart: 9 * 60,
        timeEnd: 9 * 60 + 30,
        isReminder: false,
      ),
    ]),
    act: (bloc) => bloc.add(TaskDismissed(
      Task(
        id: 1,
        title: 'A',
        status: TaskStatus.pending,
        description: null,
        dueDate: DateTime(2025, 1, 1),
        timeStart: 9 * 60,
        timeEnd: 9 * 60 + 30,
        isReminder: false,
      ),
    )),
    expect: () => [
      isA<TasksListLoaded>()
          .having((s) => s.tasks.map((t) => t.id).toList(), 'ids', [2]),
    ],
  );

  blocTest<TasksListBloc, TasksListState>(
    'TaskMarkDoneRequested -> optimistic DONE',
    build: () {
      when(() => completeTask(1)).thenAnswer(
        (_) async => Task(
          id: 1,
          title: 'A',
          status: TaskStatus.done,
          description: null,
          dueDate: DateTime(2025, 1, 1),
          timeStart: 9 * 60,
          timeEnd: 9 * 60 + 30,
          isReminder: false,
        ),
      );
      return TasksListBloc(
          getTasks: getTasks,
          deleteTask: deleteTask,
          completeTask: completeTask);
    },
    seed: () => TasksListLoaded([
      Task(
        id: 1,
        title: 'A',
        status: TaskStatus.pending,
        description: null,
        dueDate: DateTime(2025, 1, 1),
        timeStart: 9 * 60,
        timeEnd: 9 * 60 + 30,
        isReminder: false,
      ),
    ]),
    act: (bloc) => bloc.add(const TaskMarkDoneRequested(1)),
    expect: () => [
      isA<TasksListLoaded>()
          .having((s) => s.tasks.first.status, 'status', TaskStatus.done),
    ],
  );
}
