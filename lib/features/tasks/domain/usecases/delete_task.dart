import 'package:doido/features/tasks/domain/repositories/task_repository.dart';

class DeleteTask {
  final TaskRepository repo;
  const DeleteTask(this.repo);

  Future<void> call(int id) => repo.delete(id);
}
