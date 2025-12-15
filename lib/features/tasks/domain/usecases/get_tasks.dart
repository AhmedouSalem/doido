import 'package:doido/features/tasks/domain/entities/task.dart';
import 'package:doido/features/tasks/domain/repositories/task_repository.dart';

class GetTasks {
  final TaskRepository repo;
  const GetTasks(this.repo);

  Future<List<Task>> call() => repo.getAll();
}
