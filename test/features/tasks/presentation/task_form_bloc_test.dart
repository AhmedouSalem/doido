import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:doido/core/errors/exceptions.dart';
import 'package:doido/features/tasks/domain/entities/task.dart';
import 'package:doido/features/tasks/domain/entities/task_status.dart';
import 'package:doido/features/tasks/domain/usecases/create_task.dart';
import 'package:doido/features/tasks/presentation/bloc/task_form_bloc.dart';
import 'package:doido/features/tasks/presentation/bloc/task_form_event.dart';
import 'package:doido/features/tasks/presentation/bloc/task_form_state.dart';

import '../../../test_helpers/mocks.dart';

class MockCreateTask extends Mock implements CreateTask {}

void main() {
  late MockCreateTask createTask;

  setUpAll(registerFallbacks);

  setUp(() {
    createTask = MockCreateTask();
  });

  blocTest<TaskFormBloc, TaskFormState>(
    'Create success -> Submitting -> Success',
    build: () {
      when(() => createTask(any())).thenAnswer(
        (_) async => Task(
          id: 1,
          title: 'Hello',
          status: TaskStatus.pending,
          description: null,
          dueDate: DateTime(2025, 1, 1),
          timeStart: 9 * 60,
          timeEnd: 9 * 60 + 30,
          isReminder: false,
        ),
      );
      return TaskFormBloc(createTask: createTask);
    },
    act: (bloc) => bloc.add(
      TaskCreateSubmitted(
        title: 'Hello',
        dueDate: DateTime(2025, 1, 1),
        timeStart: 9 * 60,
        timeEnd: 9 * 60 + 30,
        isReminder: false,
      ),
    ),
    expect: () => [
      const TaskFormSubmitting(),
      const TaskFormSuccess(),
    ],
  );

  blocTest<TaskFormBloc, TaskFormState>(
    'Create validation error -> Submitting -> Failure',
    build: () {
      when(() => createTask(any())).thenThrow(
        const ValidationException('Le titre est requis.'),
      );
      return TaskFormBloc(createTask: createTask);
    },
    act: (bloc) => bloc.add(
      TaskCreateSubmitted(
        title: '   ',
        dueDate: DateTime(2025, 1, 1),
        timeStart: 9 * 60,
        timeEnd: 9 * 60 + 30,
        isReminder: false,
      ),
    ),
    expect: () => [
      const TaskFormSubmitting(),
      isA<TaskFormFailure>()
          .having((s) => s.message, 'message', 'Le titre est requis.'),
    ],
  );
}
