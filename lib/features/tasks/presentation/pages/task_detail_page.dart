import 'package:doido/app/di.dart';
import 'package:doido/features/tasks/domain/entities/task_status.dart';
import 'package:doido/features/tasks/presentation/bloc/task_detail_bloc.dart';
import 'package:doido/features/tasks/presentation/bloc/task_detail_event.dart';
import 'package:doido/features/tasks/presentation/bloc/task_detail_state.dart';
import 'package:doido/features/tasks/presentation/bloc/task_edit_bloc.dart';
import 'package:doido/features/tasks/presentation/pages/task_edit_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskDetailPage extends StatelessWidget {
  final int taskId;
  const TaskDetailPage({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TaskDetailBloc(
        getTaskById: DI.getTaskById,
        completeTask: DI.completeTask,
      )..add(TaskDetailRequested(taskId)),
      child: _TaskDetailScaffold(taskId: taskId),
    );
  }
}

class _TaskDetailScaffold extends StatelessWidget {
  final int taskId;
  const _TaskDetailScaffold({required this.taskId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskDetailBloc, TaskDetailState>(
      builder: (context, state) {
        if (state is TaskDetailLoading) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        if (state is TaskDetailFailure) {
          return Scaffold(
            appBar: AppBar(title: const Text('Détail')),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.message),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => context
                        .read<TaskDetailBloc>()
                        .add(TaskDetailRequested(taskId)),
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            ),
          );
        }

        final t = (state as TaskDetailLoaded).task;
        final scheme = Theme.of(context).colorScheme;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Détail'),
            actions: [
              IconButton(
                tooltip: 'Modifier',
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  final updated = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (_) => TaskEditBloc(
                          getTaskById: DI.getTaskById,
                          updateTask: DI.updateTask,
                        ),
                        child: TaskEditPage(taskId: taskId),
                      ),
                    ),
                  );

                  if (updated == true && context.mounted) {
                    context
                        .read<TaskDetailBloc>()
                        .add(TaskDetailRequested(taskId));
                  }
                },
              ),
            ],
          ),

          // ---- Premium body ----
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        t.title,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  decoration: t.status == TaskStatus.done
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    _StatusChip(status: t.status),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _InfoCard(
                      icon: Icons.event,
                      title: 'Date',
                      value: t.dueDate == null ? '—' : _fmtDate(t.dueDate!),
                    ),
                    _InfoCard(
                      icon: Icons.schedule,
                      title: 'Heure',
                      value: _timeLabel(t.timeStart, t.timeEnd, t.isReminder),
                    ),
                    _InfoCard(
                      icon: Icons.notifications_active_outlined,
                      title: 'Type',
                      value: t.isReminder ? 'Rappel' : 'Tâche',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Card(
                  color: scheme.surfaceContainerHighest,
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Description',
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        Text(
                          (t.description == null ||
                                  t.description!.trim().isEmpty)
                              ? 'Aucune description.'
                              : t.description!.trim(),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ---- Sticky actions ----
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton.tonalIcon(
                      icon: const Icon(Icons.edit),
                      label: const Text('Modifier'),
                      onPressed: () async {
                        final updated = await Navigator.push<bool>(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider(
                              create: (_) => TaskEditBloc(
                                getTaskById: DI.getTaskById,
                                updateTask: DI.updateTask,
                              ),
                              child: TaskEditPage(taskId: taskId),
                            ),
                          ),
                        );
                        if (updated == true && context.mounted) {
                          context
                              .read<TaskDetailBloc>()
                              .add(TaskDetailRequested(taskId));
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton.icon(
                      icon: const Icon(Icons.check),
                      label: const Text('Done'),
                      onPressed: t.status == TaskStatus.done
                          ? null
                          : () => context
                              .read<TaskDetailBloc>()
                              .add(TaskMarkedDone(taskId)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static String _fmtDate(DateTime d) {
    final local = d.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final m = local.month.toString().padLeft(2, '0');
    final y = local.year.toString().padLeft(4, '0');
    return '$day/$m/$y';
  }

  static String _fmtTime(int minutes) {
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
  }

  static String _timeLabel(int? start, int? end, bool isReminder) {
    if (start == null) return '—';
    if (isReminder) return _fmtTime(start);
    if (end == null) return '${_fmtTime(start)} - —';
    return '${_fmtTime(start)} - ${_fmtTime(end)}';
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  const _InfoCard(
      {required this.icon, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: scheme.onSurfaceVariant),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        color: scheme.onSurfaceVariant, fontSize: 12)),
                const SizedBox(height: 4),
                Text(value,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final TaskStatus status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final (bg, fg, label) = switch (status) {
      TaskStatus.pending => (
          scheme.secondaryContainer,
          scheme.onSecondaryContainer,
          'PENDING'
        ),
      TaskStatus.inProgress => (
          scheme.tertiaryContainer,
          scheme.onTertiaryContainer,
          'IN PROGRESS'
        ),
      TaskStatus.done => (
          scheme.primaryContainer,
          scheme.onPrimaryContainer,
          'DONE'
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Text(label,
          style:
              TextStyle(color: fg, fontWeight: FontWeight.w600, fontSize: 12)),
    );
  }
}
