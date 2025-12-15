import 'package:doido/core/utils/validators.dart';
import 'package:doido/features/tasks/domain/entities/task.dart';
import 'package:doido/features/tasks/domain/entities/task_status.dart';
import 'package:doido/features/tasks/domain/repositories/task_repository.dart';

class CreateTask {
  final TaskRepository repo;
  const CreateTask(this.repo);

  Future<Task> call(CreateTaskParams p) async {
    Validators.requireNonEmptyTitle(p.title);
    Validators.requireDueDate(p.dueDate);
    Validators.requireTimeStart(p.timeStart);
    Validators.validateStartEnd(
      timeStart: p.timeStart,
      timeEnd: p.timeEnd,
      isReminder: p.isReminder,
    );

    final created = await repo.create(
      title: p.title.trim(),
      description: p.description,
      dueDate: p.dueDate,
      timeStart: p.timeStart,
      timeEnd: p.timeEnd,
      isReminder: p.isReminder,
    );

    // Safety: statut initial doit être PENDING
    if (created.status != TaskStatus.pending) {
      // On laisse une garantie métier ici
      return created.copyWith(status: TaskStatus.pending);
    }

    return created;
  }
}

class CreateTaskParams {
  final String title;
  final String? description;
  final DateTime? dueDate;
  final int? timeStart;
  final int? timeEnd;
  final bool isReminder;

  const CreateTaskParams({
    required this.title,
    this.description,
    required this.dueDate,
    required this.timeStart,
    this.timeEnd,
    this.isReminder = false,
  });
}
