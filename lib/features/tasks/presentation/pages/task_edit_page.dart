import 'package:doido/features/tasks/presentation/bloc/task_edit_bloc.dart';
import 'package:doido/features/tasks/presentation/bloc/task_edit_event.dart';
import 'package:doido/features/tasks/presentation/bloc/task_edit_state.dart';
import 'package:doido/features/tasks/presentation/widgets/task_form_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskEditPage extends StatelessWidget {
  final int taskId;
  const TaskEditPage({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return BlocListener<TaskEditBloc, TaskEditState>(
      listener: (context, state) {
        if (state is TaskEditFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
        if (state is TaskEditSuccess) {
          Navigator.pop(context, true); // updated
        }
      },
      child: BlocBuilder<TaskEditBloc, TaskEditState>(
        builder: (context, state) {
          if (state is TaskEditLoading) {
            context.read<TaskEditBloc>().add(TaskEditRequested(taskId));
            return const Scaffold(
              key: Key('task_edit_loading_scaffold'),
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is TaskEditFailure) {
            return Scaffold(
              key: const Key('task_edit_failure_scaffold'),
              appBar: AppBar(title: const Text('Modifier')),
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.message,
                      key: const Key('task_edit_error_message'),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      key: const Key('task_edit_retry_button'),
                      onPressed: () => context
                          .read<TaskEditBloc>()
                          .add(TaskEditRequested(taskId)),
                      child: const Text('Réessayer'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is TaskEditReady || state is TaskEditSubmitting) {
            final task = state is TaskEditReady
                ? state.task
                : (state as TaskEditSubmitting).task;

            final submitting = state is TaskEditSubmitting;

            return Semantics(
              label: 'task_edit_page_$taskId',
              child: TaskFormView(
                key: const Key('task_edit_form_view'),
                title: 'Modifier la tâche',
                submitLabel: 'Enregistrer',
                submitting: submitting,

                // Preview
                statusPreview: task.status,

                // Pré-remplissage
                initialTitle: task.title,
                initialDescription: task.description,
                initialDueDate: task.dueDate,
                initialTimeStart: task.timeStart,
                initialTimeEnd: task.timeEnd,
                initialIsReminder: task.isReminder,

                onSubmit: ({
                  required String title,
                  String? description,
                  required DateTime dueDate,
                  required int timeStart,
                  int? timeEnd,
                  required bool isReminder,
                }) {
                  context.read<TaskEditBloc>().add(
                        TaskEditSubmitted(
                          id: taskId,
                          title: title,
                          description: description,
                          dueDate: dueDate,
                          timeStart: timeStart,
                          timeEnd: timeEnd,
                          isReminder: isReminder,
                        ),
                      );
                },
              ),
            );
          }

          if (state is TaskEditSuccess) {
            return const SizedBox.shrink();
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
