import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:doido/features/tasks/domain/entities/task.dart';
import 'package:doido/features/tasks/domain/entities/task_status.dart';
import 'package:doido/features/tasks/domain/usecases/get_task_by_id.dart';
import 'package:doido/features/tasks/domain/usecases/update_task.dart';
import 'package:doido/features/tasks/presentation/bloc/task_edit_bloc.dart';
import 'package:doido/features/tasks/presentation/bloc/task_edit_event.dart';
import 'package:doido/features/tasks/presentation/bloc/task_edit_state.dart';

import '../../../test_helpers/mocks.dart';

class MockGetTaskById extends Mock implements GetTaskById {}

class MockUpdateTask extends Mock implements UpdateTask {}

void main() {
  late MockGetTaskById getTaskById;
  late MockUpdateTask updateTask;

  setUpAll(registerFallbacks);

  setUp(() {
    getTaskById = MockGetTaskById();
    updateTask = MockUpdateTask();
  });

  blocTest<TaskEditBloc, TaskEditState>(
    'TaskEditRequested -> Loading -> Ready',
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
      return TaskEditBloc(getTaskById: getTaskById, updateTask: updateTask);
    },
    act: (bloc) => bloc.add(const TaskEditRequested(1)),
    expect: () => [
      const TaskEditLoading(),
      isA<TaskEditReady>().having((s) => s.task.id, 'id', 1),
    ],
  );

  blocTest<TaskEditBloc, TaskEditState>(
    'Submit -> Submitting -> Success',
    build: () {
      when(() => updateTask(any())).thenAnswer(
        (_) async => Task(
          id: 1,
          title: 'B',
          status: TaskStatus.pending,
          description: null,
          dueDate: DateTime(2025, 1, 2),
          timeStart: 10 * 60,
          timeEnd: 10 * 60 + 30,
          isReminder: false,
        ),
      );
      return TaskEditBloc(getTaskById: getTaskById, updateTask: updateTask);
    },
    seed: () => TaskEditReady(
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
    ),
    act: (bloc) => bloc.add(
      TaskEditSubmitted(
        id: 1,
        title: 'B',
        description: null,
        dueDate: DateTime(2025, 1, 2),
        timeStart: 10 * 60,
        timeEnd: 10 * 60 + 30,
        isReminder: false,
      ),
    ),
    expect: () => [
      isA<TaskEditSubmitting>(),
      const TaskEditSuccess(),
    ],
    verify: (_) => verify(() => updateTask(any())).called(1),
  );
}
