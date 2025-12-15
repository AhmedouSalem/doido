import 'package:doido/features/tasks/domain/entities/task_status.dart';
import 'package:flutter/material.dart';

class TaskFormView extends StatefulWidget {
  final String title;
  final String submitLabel;

  final String initialTitle;
  final String? initialDescription;

  // obligatoire (UI) : default = today
  final DateTime? initialDueDate;

  // obligatoire (UI) : default = now
  final int? initialTimeStart;

  // obligatoire si !isReminder : default = start + 30min
  final int? initialTimeEnd;

  final bool initialIsReminder;

  // Pour afficher un preview status (create/edit)
  final TaskStatus statusPreview;

  final bool submitting;

  final void Function({
    required String title,
    String? description,
    required DateTime dueDate,
    required int timeStart,
    int? timeEnd,
    required bool isReminder,
  }) onSubmit;

  const TaskFormView({
    super.key,
    required this.title,
    required this.submitLabel,
    required this.onSubmit,
    required this.statusPreview,
    this.submitting = false,
    this.initialTitle = '',
    this.initialDescription,
    this.initialDueDate,
    this.initialTimeStart,
    this.initialTimeEnd,
    this.initialIsReminder = false,
  });

  @override
  State<TaskFormView> createState() => _TaskFormViewState();
}

class _TaskFormViewState extends State<TaskFormView> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _descCtrl;

  late DateTime _dueDate;
  late int _timeStart;
  int? _timeEnd;
  late bool _isReminder;

  String? _titleError;
  String? _timeError;

  @override
  void initState() {
    super.initState();

    _titleCtrl = TextEditingController(text: widget.initialTitle);
    _descCtrl = TextEditingController(text: widget.initialDescription ?? '');

    final now = DateTime.now();
    _dueDate = widget.initialDueDate ?? DateTime(now.year, now.month, now.day);

    _timeStart = widget.initialTimeStart ?? _minutesFromNow();
    _isReminder = widget.initialIsReminder;

    final defaultEnd = (_timeStart + 30).clamp(0, 1439);
    _timeEnd = widget.initialTimeEnd ?? (_isReminder ? null : defaultEnd);

    // format 24h (force)
    // -> géré via MediaQuery override dans showTimePicker
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // ---- Status Preview ----
            Row(
              children: [
                const Text('Statut: '),
                _StatusChip(status: widget.statusPreview),
              ],
            ),
            const SizedBox(height: 14),

            // ---- Section: Infos ----
            Text('Informations',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),

            TextField(
              controller: _titleCtrl,
              onChanged: (_) => _validateTitle(live: true),
              decoration: InputDecoration(
                labelText: 'Titre *',
                border: const OutlineInputBorder(),
                errorText: _titleError,
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _descCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description (optionnelle)',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 18),

            // ---- Section: Échéance ----
            Text('Échéance', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),

            Card(
              color: scheme.surfaceContainerHighest,
              child: ListTile(
                title: const Text('Date *'),
                subtitle: Text(_fmtDate(_dueDate)),
                trailing: IconButton(
                  icon: const Icon(Icons.event),
                  onPressed:
                      widget.submitting ? null : () => _pickDueDate(context),
                ),
              ),
            ),

            const SizedBox(height: 18),

            // ---- Section: Temps ----
            Row(
              children: [
                Expanded(
                  child: Text('Temps',
                      style: Theme.of(context).textTheme.titleMedium),
                ),
                Switch(
                  value: _isReminder,
                  onChanged: widget.submitting
                      ? null
                      : (v) {
                          setState(() {
                            _isReminder = v;
                            if (_isReminder) {
                              _timeEnd = null;
                            } else {
                              _timeEnd ??= (_timeStart + 30).clamp(0, 1439);
                            }
                          });
                          _validateTimes(live: true);
                        },
                ),
                const SizedBox(width: 6),
                const Text('Rappel'),
              ],
            ),
            const SizedBox(height: 10),

            if (_timeError != null) ...[
              Text(_timeError!, style: TextStyle(color: scheme.error)),
              const SizedBox(height: 8),
            ],

            Card(
              color: scheme.surfaceContainerHighest,
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Heure de début *'),
                    subtitle: Text(_fmtTime(_timeStart)),
                    trailing: IconButton(
                      icon: const Icon(Icons.access_time),
                      onPressed: widget.submitting
                          ? null
                          : () => _pickStartTime(context),
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    enabled: !_isReminder,
                    title: Text(_isReminder
                        ? 'Heure de fin (désactivée)'
                        : 'Heure de fin *'),
                    subtitle: Text(_isReminder ? '—' : _fmtTime(_timeEnd)),
                    trailing: IconButton(
                      icon: const Icon(Icons.access_time_filled),
                      onPressed: widget.submitting || _isReminder
                          ? null
                          : () => _pickEndTime(context),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // ---- CTA ----
            FilledButton(
              onPressed: widget.submitting ? null : _submit,
              child: widget.submitting
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(widget.submitLabel),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    final okTitle = _validateTitle(live: false);
    final okTimes = _validateTimes(live: false);

    if (!okTitle || !okTimes) return;

    widget.onSubmit(
      title: _titleCtrl.text,
      description: _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
      dueDate: _dueDate,
      timeStart: _timeStart,
      timeEnd: _isReminder ? null : _timeEnd,
      isReminder: _isReminder,
    );
  }

  bool _validateTitle({required bool live}) {
    final value = _titleCtrl.text.trim();
    final err = value.isEmpty ? 'Le titre est requis.' : null;

    if (live) {
      setState(() => _titleError = err);
    } else {
      _titleError = err;
      setState(() {});
    }

    return err == null;
  }

  bool _validateTimes({required bool live}) {
    String? err;

    // start always present
    // end required if not reminder
    if (!_isReminder && _timeEnd == null) {
      err = 'L’heure de fin est requise (hors rappel).';
    } else if (!_isReminder && _timeEnd != null && _timeEnd! < _timeStart) {
      err = 'L’heure de fin doit être ≥ à l’heure de début.';
    }

    if (live) {
      setState(() => _timeError = err);
    } else {
      _timeError = err;
      setState(() {});
    }

    return err == null;
  }

  Future<void> _pickDueDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime(_dueDate.year - 2),
      lastDate: DateTime(_dueDate.year + 10),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  Future<void> _pickStartTime(BuildContext context) async {
    final picked = await _show24hTimePicker(
      context,
      initial: _toTimeOfDay(_timeStart),
    );
    if (picked == null) return;

    setState(() {
      _timeStart = picked.hour * 60 + picked.minute;
      if (!_isReminder) {
        // Keep end at least start, default to start +30
        final candidate = (_timeStart + 30).clamp(0, 1439);
        if (_timeEnd == null || _timeEnd! < _timeStart) _timeEnd = candidate;
      }
    });
    _validateTimes(live: true);
  }

  Future<void> _pickEndTime(BuildContext context) async {
    final initial = _timeEnd ?? (_timeStart + 30).clamp(0, 1439);
    final picked = await _show24hTimePicker(
      context,
      initial: _toTimeOfDay(initial),
    );
    if (picked == null) return;

    setState(() {
      _timeEnd = picked.hour * 60 + picked.minute;
    });
    _validateTimes(live: true);
  }

  Future<TimeOfDay?> _show24hTimePicker(BuildContext context,
      {required TimeOfDay initial}) {
    return showTimePicker(
      context: context,
      initialTime: initial,
      builder: (context, child) {
        final mq = MediaQuery.of(context);
        return MediaQuery(
          data: mq.copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
  }

  int _minutesFromNow() {
    final now = DateTime.now();
    return (now.hour * 60 + now.minute).clamp(0, 1439);
  }

  String _fmtDate(DateTime d) {
    final local = d.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final m = local.month.toString().padLeft(2, '0');
    final y = local.year.toString().padLeft(4, '0');
    return '$day/$m/$y';
  }

  String _fmtTime(int? minutes) {
    if (minutes == null) return '--:--';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
  }

  TimeOfDay _toTimeOfDay(int minutes) {
    return TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60);
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
