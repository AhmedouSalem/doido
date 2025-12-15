import 'package:doido/features/tasks/domain/entities/task_status.dart';
import 'package:doido/features/tasks/presentation/bloc/task_form_bloc.dart';
import 'package:doido/features/tasks/presentation/bloc/task_form_event.dart';
import 'package:doido/features/tasks/presentation/bloc/task_form_state.dart';
import 'package:doido/features/tasks/presentation/widgets/task_form_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskFormPage extends StatelessWidget {
  const TaskFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<TaskFormBloc, TaskFormState>(
      listener: (context, state) {
        if (state is TaskFormFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
        if (state is TaskFormSuccess) {
          Navigator.pop(context, true); // created
        }
      },
      child: BlocBuilder<TaskFormBloc, TaskFormState>(
        builder: (context, state) {
          final submitting = state is TaskFormSubmitting;

          return TaskFormView(
            title: 'Créer une tâche',
            submitLabel: 'Créer',
            submitting: submitting,
            statusPreview: TaskStatus.pending,
            initialDueDate: DateTime.now(),
            initialTimeStart: null, // laisse le widget prendre "now"
            initialTimeEnd: null,
            initialIsReminder: false,
            onSubmit: (
                {required String title,
                String? description,
                required DateTime dueDate,
                required int timeStart,
                int? timeEnd,
                required bool isReminder}) {
              context.read<TaskFormBloc>().add(
                    TaskCreateSubmitted(
                      title: title,
                      description: description,
                      dueDate: dueDate,
                      timeStart: timeStart,
                      timeEnd: timeEnd,
                      isReminder: isReminder,
                    ),
                  );
            },
          );
        },
      ),
    );
  }
}
