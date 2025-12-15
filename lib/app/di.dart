import 'package:doido/features/tasks/data/datasources/task_local_datasource.dart';
import 'package:doido/features/tasks/data/db/app_database.dart';
import 'package:doido/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:doido/features/tasks/domain/repositories/task_repository.dart';
import 'package:doido/features/tasks/domain/usecases/complete_task.dart';
import 'package:doido/features/tasks/domain/usecases/create_task.dart';
import 'package:doido/features/tasks/domain/usecases/delete_task.dart';
import 'package:doido/features/tasks/domain/usecases/get_task_by_id.dart';
import 'package:doido/features/tasks/domain/usecases/get_tasks.dart';
import 'package:doido/features/tasks/domain/usecases/update_task.dart';

class DI {
  DI._();

  static final db = AppDatabase.instance;

  static final taskLocalDataSource = TaskLocalDataSource(db);

  static final TaskRepository taskRepository =
      TaskRepositoryImpl(taskLocalDataSource);

  static final getTasks = GetTasks(taskRepository);
  static final deleteTask = DeleteTask(taskRepository);

  static final createTask = CreateTask(taskRepository);

  static final getTaskById = GetTaskById(taskRepository);
  static final completeTask = CompleteTask(taskRepository);
  static final updateTask = UpdateTask(taskRepository);
}
