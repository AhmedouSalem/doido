import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:doido/core/errors/exceptions.dart';
import 'package:doido/features/tasks/domain/entities/task.dart';
import 'package:doido/features/tasks/domain/entities/task_status.dart';
import 'package:doido/features/tasks/domain/usecases/create_task.dart';

import '../../../test_helpers/mocks.dart';

void main() {
  late MockTaskRepository repo;
  late CreateTask usecase;

  setUpAll(registerFallbacks);

  setUp(() {
    repo = MockTaskRepository();
    usecase = CreateTask(repo);
  });

  test('CreateTask - throws ValidationException when title is empty', () async {
    expect(
      () => usecase(
        CreateTaskParams(
          title: '   ',
          dueDate: DateTime(2025, 1, 1),
          timeStart: 9 * 60,
          timeEnd: 9 * 60 + 30,
          isReminder: false,
        ),
      ),
      throwsA(isA<ValidationException>()),
    );

    verifyNever(() => repo.create(
          title: any(named: 'title'),
          description: any(named: 'description'),
          dueDate: any(named: 'dueDate'),
          timeStart: any(named: 'timeStart'),
          timeEnd: any(named: 'timeEnd'),
          isReminder: any(named: 'isReminder'),
        ));
  });

  test('CreateTask - requires end time when isReminder=false', () async {
    expect(
      () => usecase(
        CreateTaskParams(
          title: 'Task',
          dueDate: DateTime(2025, 1, 1),
          timeStart: 9 * 60,
          timeEnd: null,
          isReminder: false,
        ),
      ),
      throwsA(isA<ValidationException>()),
    );
  });

  test('CreateTask - allows end time null when isReminder=true', () async {
    final created = Task(
      id: 1,
      title: 'Reminder',
      status: TaskStatus.pending,
      description: null,
      dueDate: DateTime(2025, 1, 1),
      timeStart: 9 * 60,
      timeEnd: null,
      isReminder: true,
    );

    when(() => repo.create(
          title: any(named: 'title'),
          description: any(named: 'description'),
          dueDate: any(named: 'dueDate'),
          timeStart: any(named: 'timeStart'),
          timeEnd: any(named: 'timeEnd'),
          isReminder: any(named: 'isReminder'),
        )).thenAnswer((_) async => created);

    final result = await usecase(
      CreateTaskParams(
        title: '  Reminder  ',
        dueDate: DateTime(2025, 1, 1),
        timeStart: 9 * 60,
        timeEnd: null,
        isReminder: true,
      ),
    );

    expect(result.title, 'Reminder');
    expect(result.isReminder, true);
    expect(result.timeEnd, isNull);

    verify(() => repo.create(
          title: 'Reminder',
          description: null,
          dueDate: DateTime(2025, 1, 1),
          timeStart: 9 * 60,
          timeEnd: null,
          isReminder: true,
        )).called(1);
  });

  test('CreateTask - calls repo.create with trimmed title', () async {
    final created = Task(
      id: 2,
      title: 'Hello',
      status: TaskStatus.pending,
      description: null,
      dueDate: DateTime(2025, 1, 1),
      timeStart: 9 * 60,
      timeEnd: 9 * 60 + 30,
      isReminder: false,
    );

    when(() => repo.create(
          title: any(named: 'title'),
          description: any(named: 'description'),
          dueDate: any(named: 'dueDate'),
          timeStart: any(named: 'timeStart'),
          timeEnd: any(named: 'timeEnd'),
          isReminder: any(named: 'isReminder'),
        )).thenAnswer((_) async => created);

    final result = await usecase(
      CreateTaskParams(
        title: '  Hello  ',
        dueDate: DateTime(2025, 1, 1),
        timeStart: 9 * 60,
        timeEnd: 9 * 60 + 30,
        isReminder: false,
      ),
    );

    expect(result.title, 'Hello');
    expect(result.status, TaskStatus.pending);

    verify(() => repo.create(
          title: 'Hello',
          description: null,
          dueDate: DateTime(2025, 1, 1),
          timeStart: 9 * 60,
          timeEnd: 9 * 60 + 30,
          isReminder: false,
        )).called(1);
  });
}
