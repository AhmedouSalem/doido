import 'package:mocktail/mocktail.dart';

import 'package:doido/features/tasks/domain/entities/task.dart';
import 'package:doido/features/tasks/domain/entities/task_status.dart';
import 'package:doido/features/tasks/domain/repositories/task_repository.dart';
import 'package:doido/features/tasks/domain/usecases/create_task.dart';
import 'package:doido/features/tasks/domain/usecases/update_task.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

class FakeTask extends Fake implements Task {}

void registerFallbacks() {
  registerFallbackValue(FakeTask());
  registerFallbackValue(TaskStatus.pending);

  registerFallbackValue(
    CreateTaskParams(
      title: 'fallback',
      dueDate: DateTime(2025, 1, 1),
      timeStart: 9 * 60,
      timeEnd: 9 * 60 + 30,
      isReminder: false,
    ),
  );

  registerFallbackValue(
    UpdateTaskParams(
      id: 1,
      title: 'fallback',
      dueDate: DateTime(2025, 1, 1),
      timeStart: 9 * 60,
      timeEnd: 9 * 60 + 30,
      isReminder: false,
    ),
  );
}
