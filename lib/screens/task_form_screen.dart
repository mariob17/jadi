import 'package:flutter/material.dart';

import '../models/study_task.dart';

const taskCategories = ['Belajar', 'Tugas', 'Proyek', 'Lainnya'];

class TaskFormScreen extends StatefulWidget {
  const TaskFormScreen({this.initialTask, super.key});

  final StudyTask? initialTask;

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late String _category;
  late TaskPriority _priority;
  DateTime? _dueDate;

  bool get _isEditing => widget.initialTask != null;

  @override
  void initState() {
    super.initState();
    final task = widget.initialTask;
    _titleController = TextEditingController(text: task?.title ?? '');
    _descriptionController =
        TextEditingController(text: task?.description ?? '');
    _category = task?.category ?? taskCategories.first;
    _priority = task?.priority ?? TaskPriority.medium;
    _dueDate = task?.dueDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365 * 5)),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  void _save() {
    if (_formKey.currentState?.validate() != true) return;

    final oldTask = widget.initialTask;
    final task = StudyTask(
      id: oldTask?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _category,
      priority: _priority,
      dueDate: _dueDate,
      completed: oldTask?.completed ?? false,
    );
    Navigator.of(context).pop(task);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit tugas' : 'Tambah tugas')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                TextFormField(
                  key: const Key('task-title'),
                  controller: _titleController,
                  autofocus: !_isEditing,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Nama tugas',
                    hintText: 'Contoh: Membaca materi Flutter',
                    prefixIcon: Icon(Icons.menu_book_outlined),
                  ),
                  validator: (value) {
                    final title = value?.trim() ?? '';
                    if (title.isEmpty) return 'Nama tugas wajib diisi.';
                    if (title.length < 3) {
                      return 'Nama tugas minimal 3 karakter.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                TextFormField(
                  key: const Key('task-description'),
                  controller: _descriptionController,
                  textCapitalization: TextCapitalization.sentences,
                  minLines: 2,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Catatan (opsional)',
                    alignLabelWithHint: true,
                    prefixIcon: Icon(Icons.notes_outlined),
                  ),
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  initialValue: _category,
                  decoration: const InputDecoration(
                    labelText: 'Kategori',
                    prefixIcon: Icon(Icons.category_outlined),
                  ),
                  items: [
                    for (final category in taskCategories)
                      DropdownMenuItem(value: category, child: Text(category)),
                  ],
                  onChanged: (value) {
                    if (value != null) setState(() => _category = value);
                  },
                ),
                const SizedBox(height: 20),
                Text('Prioritas', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final priority in TaskPriority.values)
                      ChoiceChip(
                        label: Text(priority.label),
                        selected: _priority == priority,
                        onSelected: (_) => setState(() => _priority = priority),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _pickDate,
                        icon: const Icon(Icons.event_outlined),
                        label: Text(
                          _dueDate == null
                              ? 'Pilih tenggat'
                              : '${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}',
                        ),
                      ),
                    ),
                    if (_dueDate != null)
                      IconButton(
                        tooltip: 'Hapus tenggat',
                        onPressed: () => setState(() => _dueDate = null),
                        icon: const Icon(Icons.close),
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.save_outlined),
                  label: Text(_isEditing ? 'Simpan perubahan' : 'Simpan tugas'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
