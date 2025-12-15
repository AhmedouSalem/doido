import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:doido/core/errors/exceptions.dart';
import 'package:doido/features/tasks/domain/entities/task.dart';
import 'package:doido/features/tasks/domain/entities/task_status.dart';
import 'package:doido/features/tasks/domain/usecases/update_task.dart';

import '../../../test_helpers/mocks.dart';

void main() {
  late MockTaskRepository repo;
  late UpdateTask usecase;

  setUpAll(registerFallbacks);

  setUp(() {
    repo = MockTaskRepository();
    usecase = UpdateTask(repo);
  });

  test('UpdateTask - throws ValidationException if title provided but empty',
      () async {
    expect(
      () => usecase(
        UpdateTaskParams(
          id: 10,
          title: '   ',
          dueDate: DateTime(2025, 1, 2),
          timeStart: 10 * 60,
          timeEnd: 10 * 60 + 30,
          isReminder: false,
        ),
      ),
      throwsA(isA<ValidationException>()),
    );
  });

  test('UpdateTask - requires end time when isReminder=false', () async {
    expect(
      () => usecase(
        UpdateTaskParams(
          id: 10,
          title: 'New',
          dueDate: DateTime(2025, 1, 2),
          timeStart: 10 * 60,
          timeEnd: null,
          isReminder: false,
        ),
      ),
      throwsA(isA<ValidationException>()),
    );
  });

  test('UpdateTask - allows end time null when isReminder=true', () async {
    final updated = Task(
      id: 10,
      title: 'Rem',
      status: TaskStatus.inProgress,
      description: null,
      dueDate: DateTime(2025, 1, 2),
      timeStart: 10 * 60,
      timeEnd: null,
      isReminder: true,
    );

    when(() => repo.update(
          id: any(named: 'id'),
          title: any(named: 'title'),
          description: any(named: 'description'),
          dueDate: any(named: 'dueDate'),
          timeStart: any(named: 'timeStart'),
          timeEnd: any(named: 'timeEnd'),
          isReminder: any(named: 'isReminder'),
        )).thenAnswer((_) async => updated);

    final result = await usecase(
      UpdateTaskParams(
        id: 10,
        title: '  Rem  ',
        dueDate: DateTime(2025, 1, 2),
        timeStart: 10 * 60,
        timeEnd: null,
        isReminder: true,
      ),
    );

    expect(result.isReminder, true);
    expect(result.timeEnd, isNull);

    verify(() => repo.update(
          id: 10,
          title: 'Rem',
          description: null,
          dueDate: DateTime(2025, 1, 2),
          timeStart: 10 * 60,
          timeEnd: null,
          isReminder: true,
        )).called(1);
  });

  test(
      'UpdateTask - calls repo.update with trimmed title and keeps status untouched by usecase',
      () async {
    final updated = Task(
      id: 10,
      title: 'New',
      status: TaskStatus.inProgress,
      description: null,
      dueDate: DateTime(2025, 1, 2),
      timeStart: 10 * 60,
      timeEnd: 10 * 60 + 30,
      isReminder: false,
    );

    when(() => repo.update(
          id: any(named: 'id'),
          title: any(named: 'title'),
          description: any(named: 'description'),
          dueDate: any(named: 'dueDate'),
          timeStart: any(named: 'timeStart'),
          timeEnd: any(named: 'timeEnd'),
          isReminder: any(named: 'isReminder'),
        )).thenAnswer((_) async => updated);

    final result = await usecase(
      UpdateTaskParams(
        id: 10,
        title: '  New  ',
        dueDate: DateTime(2025, 1, 2),
        timeStart: 10 * 60,
        timeEnd: 10 * 60 + 30,
        isReminder: false,
      ),
    );

    expect(result.title, 'New');
    expect(result.status, TaskStatus.inProgress);

    verify(() => repo.update(
          id: 10,
          title: 'New',
          description: null,
          dueDate: DateTime(2025, 1, 2),
          timeStart: 10 * 60,
          timeEnd: 10 * 60 + 30,
          isReminder: false,
        )).called(1);
  });
}
