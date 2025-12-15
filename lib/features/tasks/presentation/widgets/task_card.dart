import 'package:flutter/material.dart';
import '../../domain/entities/task.dart';
import '../../domain/entities/task_status.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onMarkDone;

  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    required this.onDelete,
    required this.onMarkDone,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final titleStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
          decoration: task.status == TaskStatus.done
              ? TextDecoration.lineThrough
              : null,
        );

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _StatusDot(status: task.status),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text(task.title, style: titleStyle)),
                        const SizedBox(width: 8),
                        _StatusChip(status: task.status),
                      ],
                    ),
                    if (task.description != null &&
                        task.description!.trim().isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        task.description!.trim(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        if (task.dueDate != null)
                          _InfoPill(
                              icon: Icons.event, text: _fmtDate(task.dueDate!)),
                        if (task.timeStart != null && task.timeEnd != null)
                          _InfoPill(
                              icon: Icons.schedule,
                              text:
                                  '${_fmtTime(task.timeStart!)} - ${_fmtTime(task.timeEnd!)}'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        if (task.status != TaskStatus.done)
                          FilledButton.icon(
                            onPressed: onMarkDone,
                            icon: const Icon(Icons.check),
                            label: const Text('Done'),
                          ),
                        const Spacer(),
                        IconButton(
                          tooltip: 'Supprimer',
                          onPressed: onDelete,
                          icon: const Icon(Icons.delete_outline),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _fmtDate(DateTime d) {
    final local = d.toLocal();
    final y = local.year.toString().padLeft(4, '0');
    final m = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    return '$day/$m/$y';
    // si tu veux “Aujourd’hui/Demain”, on le fera après
  }

  String _fmtTime(int minutes) {
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
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
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label,
          style:
              TextStyle(color: fg, fontWeight: FontWeight.w600, fontSize: 12)),
    );
  }
}

class _StatusDot extends StatelessWidget {
  final TaskStatus status;
  const _StatusDot({required this.status});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = switch (status) {
      TaskStatus.pending => scheme.secondary,
      TaskStatus.inProgress => scheme.tertiary,
      TaskStatus.done => scheme.primary,
    };

    return Container(
      margin: const EdgeInsets.only(top: 6),
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoPill({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: scheme.onSurfaceVariant),
          const SizedBox(width: 6),
          Text(text, style: TextStyle(color: scheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}
