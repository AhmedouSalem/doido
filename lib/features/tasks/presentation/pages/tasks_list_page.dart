import 'package:doido/app/di.dart';
import 'package:doido/features/tasks/domain/entities/task.dart';
import 'package:doido/features/tasks/domain/entities/task_status.dart';
import 'package:doido/features/tasks/presentation/bloc/task_form_bloc.dart';
import 'package:doido/features/tasks/presentation/bloc/tasks_list_bloc.dart';
import 'package:doido/features/tasks/presentation/bloc/tasks_list_event.dart';
import 'package:doido/features/tasks/presentation/bloc/tasks_list_state.dart';
import 'package:doido/features/tasks/presentation/pages/task_detail_page.dart';
import 'package:doido/features/tasks/presentation/pages/task_form_page.dart';
import 'package:doido/features/tasks/presentation/widgets/task_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum TaskFilter { all, pending, inProgress, done }

enum TaskSort { createdDesc, dueAsc, dueDesc, titleAsc }

class TasksListPage extends StatefulWidget {
  const TasksListPage({super.key});

  @override
  State<TasksListPage> createState() => _TasksListPageState();
}

class _TasksListPageState extends State<TasksListPage> {
  final _searchCtrl = TextEditingController();
  TaskFilter _filter = TaskFilter.all;
  TaskSort _sort = TaskSort.createdDesc;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TasksListBloc, TasksListState>(
      listener: (context, state) {
        if (state is TasksListFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<TasksListBloc, TasksListState>(
            builder: (context, state) {
              if (state is TasksListInitial) {
                context.read<TasksListBloc>().add(const TasksRequested());
                return const SizedBox.shrink();
              }

              if (state is TasksListLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is TasksListFailure) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(state.message),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => context
                            .read<TasksListBloc>()
                            .add(const TasksRequested()),
                        child: const Text('Réessayer'),
                      ),
                    ],
                  ),
                );
              }

              final tasks = (state as TasksListLoaded).tasks;
              final view = _applyView(tasks);

              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    title: const Text('TodoManager'),
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(118),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                        child: Column(
                          children: [
                            TextField(
                              controller: _searchCtrl,
                              onChanged: (_) => setState(() {}),
                              decoration: InputDecoration(
                                hintText: 'Rechercher (titre / description)',
                                prefixIcon: const Icon(Icons.search),
                                suffixIcon: _searchCtrl.text.isEmpty
                                    ? null
                                    : IconButton(
                                        icon: const Icon(Icons.clear),
                                        onPressed: () {
                                          _searchCtrl.clear();
                                          setState(() {});
                                        },
                                      ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(child: _filterChips()),
                                const SizedBox(width: 8),
                                _sortMenu(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (view.isEmpty)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(child: Text('Aucune tâche.')),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverList.separated(
                        itemCount: view.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final task = view[index];

                          return Dismissible(
                            key: ValueKey('task_${task.id}'),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 18),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Theme.of(context)
                                    .colorScheme
                                    .errorContainer,
                              ),
                              child: Icon(Icons.delete,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onErrorContainer),
                            ),
                            onDismissed: (_) {
                              context
                                  .read<TasksListBloc>()
                                  .add(TaskDismissed(task));

                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('“${task.title}” supprimée'),
                                  action: SnackBarAction(
                                    label: 'Annuler',
                                    onPressed: () => context
                                        .read<TasksListBloc>()
                                        .add(TaskUndoDeleteRequested(task.id)),
                                  ),
                                ),
                              );
                            },
                            child: TaskCard(
                              task: task,
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        TaskDetailPage(taskId: task.id),
                                  ),
                                );

                                if (context.mounted) {
                                  context
                                      .read<TasksListBloc>()
                                      .add(const TasksRefreshed());
                                }
                              },
                              onDelete: () async {
                                final ok = await _confirmDelete(context, task);
                                if (ok && context.mounted) {
                                  context
                                      .read<TasksListBloc>()
                                      .add(TaskDismissed(task));
                                  ScaffoldMessenger.of(context)
                                      .clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text('“${task.title}” supprimée'),
                                      action: SnackBarAction(
                                        label: 'Annuler',
                                        onPressed: () => context
                                            .read<TasksListBloc>()
                                            .add(TaskUndoDeleteRequested(
                                                task.id)),
                                      ),
                                    ),
                                  );
                                }
                              },
                              onMarkDone: () => context
                                  .read<TasksListBloc>()
                                  .add(TaskMarkDoneRequested(task.id)),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.add),
          label: const Text('Nouvelle tâche'),
          onPressed: () async {
            final created = await Navigator.push<bool>(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider(
                  create: (_) => TaskFormBloc(createTask: DI.createTask),
                  child: const TaskFormPage(),
                ),
              ),
            );
            if (created == true && context.mounted) {
              context.read<TasksListBloc>().add(const TasksRefreshed());
            }
          },
        ),
      ),
    );
  }

  List<Task> _applyView(List<Task> tasks) {
    final q = _searchCtrl.text.trim().toLowerCase();

    List<Task> out = tasks.where((t) {
      final matchesQuery = q.isEmpty ||
          t.title.toLowerCase().contains(q) ||
          (t.description?.toLowerCase().contains(q) ?? false);

      final matchesFilter = switch (_filter) {
        TaskFilter.all => true,
        TaskFilter.pending => t.status == TaskStatus.pending,
        TaskFilter.inProgress => t.status == TaskStatus.inProgress,
        TaskFilter.done => t.status == TaskStatus.done,
      };

      return matchesQuery && matchesFilter;
    }).toList();

    out.sort((a, b) {
      switch (_sort) {
        case TaskSort.createdDesc:
          return b.id.compareTo(a.id);
        case TaskSort.titleAsc:
          return a.title.toLowerCase().compareTo(b.title.toLowerCase());
        case TaskSort.dueAsc:
          final ad = a.dueDate;
          final bd = b.dueDate;
          if (ad == null && bd == null) return 0;
          if (ad == null) return 1;
          if (bd == null) return -1;
          return ad.compareTo(bd);
        case TaskSort.dueDesc:
          final ad = a.dueDate;
          final bd = b.dueDate;
          if (ad == null && bd == null) return 0;
          if (ad == null) return 1;
          if (bd == null) return -1;
          return bd.compareTo(ad);
      }
    });

    return out;
  }

  Widget _filterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Wrap(
        spacing: 8,
        children: [
          _chip(TaskFilter.all, 'All'),
          _chip(TaskFilter.pending, 'Pending'),
          _chip(TaskFilter.inProgress, 'In progress'),
          _chip(TaskFilter.done, 'Done'),
        ],
      ),
    );
  }

  Widget _chip(TaskFilter f, String label) {
    final selected = _filter == f;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => setState(() => _filter = f),
    );
  }

  Widget _sortMenu() {
    return PopupMenuButton<TaskSort>(
      tooltip: 'Trier',
      onSelected: (v) => setState(() => _sort = v),
      itemBuilder: (context) => const [
        PopupMenuItem(
            value: TaskSort.createdDesc, child: Text('Création (récent)')),
        PopupMenuItem(
            value: TaskSort.dueAsc, child: Text('Échéance (croissant)')),
        PopupMenuItem(
            value: TaskSort.dueDesc, child: Text('Échéance (décroissant)')),
        PopupMenuItem(value: TaskSort.titleAsc, child: Text('Titre (A → Z)')),
      ],
      child: FilledButton.tonalIcon(
        onPressed: null,
        icon: const Icon(Icons.sort),
        label: const Text('Trier'),
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context, Task task) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer la tâche ?'),
        content: Text('“${task.title}” sera supprimée.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Annuler')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Supprimer')),
        ],
      ),
    );
    return ok == true;
  }
}
