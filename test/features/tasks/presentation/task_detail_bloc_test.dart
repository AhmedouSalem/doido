import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:doido/features/tasks/domain/entities/task.dart';
import 'package:doido/features/tasks/domain/entities/task_status.dart';
import 'package:doido/features/tasks/domain/usecases/complete_task.dart';
import 'package:doido/features/tasks/domain/usecases/get_task_by_id.dart';
import 'package:doido/features/tasks/presentation/bloc/task_detail_bloc.dart';
import 'package:doido/features/tasks/presentation/bloc/task_detail_event.dart';
import 'package:doido/features/tasks/presentation/bloc/task_detail_state.dart';

class MockGetTaskById extends Mock implements GetTaskById {}

class MockCompleteTask extends Mock implements CompleteTask {}

void main() {
  late MockGetTaskById getTaskById;
  late MockCompleteTask completeTask;

  setUp(() {
    getTaskById = MockGetTaskById();
    completeTask = MockCompleteTask();
  });

  blocTest<TaskDetailBloc, TaskDetailState>(
    'Requested -> Loading -> Loaded',
    build: () {
      when(() => getTaskById(1)).thenAnswer(
        (_) async => Task(
          id: 1,
          title: 'A',
          status: TaskStatus.pending,
          description: null,
          dueDate: DateTime(2025, 1, 1),
          timeStart: 9 * 60,
          timeEnd: 9 * 60 + 30,
          isReminder: false,
        ),
      );
      return TaskDetailBloc(
          getTaskById: getTaskById, completeTask: completeTask);
    },
    act: (bloc) => bloc.add(const TaskDetailRequested(1)),
    expect: () => [
      isA<TaskDetailLoading>(),
      isA<TaskDetailLoaded>().having((s) => s.task.id, 'id', 1),
    ],
  );

  blocTest<TaskDetailBloc, TaskDetailState>(
    'Mark done -> Loaded with DONE',
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
      when(() => getTaskById(1)).thenAnswer(
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
      return TaskDetailBloc(
          getTaskById: getTaskById, completeTask: completeTask);
    },
    act: (bloc) => bloc.add(const TaskMarkedDone(1)),
    expect: () => [
      isA<TaskDetailLoaded>()
          .having((s) => s.task.status, 'status', TaskStatus.done),
    ],
  );
}
