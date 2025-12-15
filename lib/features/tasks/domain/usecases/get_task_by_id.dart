import 'package:doido/features/tasks/domain/entities/task.dart';
import 'package:doido/features/tasks/domain/repositories/task_repository.dart';

class GetTaskById {
  final TaskRepository repo;
  const GetTaskById(this.repo);

  Future<Task> call(int id) => repo.getById(id);
}
