import 'package:doido/features/tasks/domain/entities/task.dart';
import 'package:doido/features/tasks/domain/entities/task_status.dart';
import 'package:doido/features/tasks/domain/repositories/task_repository.dart';

class CompleteTask {
  final TaskRepository repo;
  const CompleteTask(this.repo);

  Future<Task> call(int id) {
    return repo.updateStatus(id: id, status: TaskStatus.done);
  }
}
