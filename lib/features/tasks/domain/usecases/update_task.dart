import 'package:doido/core/utils/validators.dart';
import 'package:doido/features/tasks/domain/entities/task.dart';
import 'package:doido/features/tasks/domain/repositories/task_repository.dart';

class UpdateTask {
  final TaskRepository repo;
  const UpdateTask(this.repo);

  Future<Task> call(UpdateTaskParams p) async {
    if (p.title != null) {
      Validators.requireNonEmptyTitle(p.title!);
    }

    Validators.requireDueDate(p.dueDate);
    Validators.requireTimeStart(p.timeStart);

    Validators.validateStartEnd(
      timeStart: p.timeStart,
      timeEnd: p.timeEnd,
      isReminder: p.isReminder,
    );

    return repo.update(
      id: p.id,
      title: p.title?.trim(),
      description: p.description,
      dueDate: p.dueDate,
      timeStart: p.timeStart,
      timeEnd: p.timeEnd,
      isReminder: p.isReminder,
    );
  }
}

class UpdateTaskParams {
  final int id;
  final String? title;
  final String? description;
  final DateTime? dueDate;
  final int? timeStart;
  final int? timeEnd;
  final bool isReminder;

  const UpdateTaskParams({
    required this.id,
    this.title,
    this.description,
    required this.dueDate,
    required this.timeStart,
    this.timeEnd,
    this.isReminder = false,
  });
}
