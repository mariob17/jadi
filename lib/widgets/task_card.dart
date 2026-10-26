import 'package:flutter/material.dart';

import '../models/study_task.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    required this.task,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final StudyTask task;
  final ValueChanged<bool> onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final dueDate = task.dueDate;
    final dueDateLabel = dueDate == null
        ? 'Tanpa tenggat'
        : 'Tenggat ${dueDate.day}/${dueDate.month}/${dueDate.year}';

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
        child: Row(
          children: [
            Checkbox(
              key: ValueKey('complete-${task.id}'),
              value: task.completed,
              onChanged: (value) => onToggle(value ?? false),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    task.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          decoration: task.completed
                              ? TextDecoration.lineThrough
                              : null,
                          color: task.completed
                              ? colors.onSurfaceVariant
                              : colors.onSurface,
                        ),
                  ),
                  if (task.description.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      task.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 7),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      _InfoChip(
                        icon: Icons.bookmark_outline,
                        label: task.category,
                      ),
                      _InfoChip(
                        icon: Icons.flag_outlined,
                        label: task.priority.label,
                      ),
                      _InfoChip(icon: Icons.event_outlined, label: dueDateLabel),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Edit tugas',
              onPressed: onEdit,
              icon: const Icon(Icons.edit_outlined),
            ),
            IconButton(
              key: ValueKey('delete-${task.id}'),
              tooltip: 'Hapus tugas',
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 15),
      label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      labelPadding: const EdgeInsets.only(right: 6),
    );
  }
}
