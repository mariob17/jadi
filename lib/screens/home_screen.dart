import 'package:flutter/material.dart';

import '../models/study_task.dart';
import '../widgets/progress_summary.dart';
import '../widgets/task_card.dart';
import 'task_form_screen.dart';

enum TaskFilter { all, active, completed }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  final List<StudyTask> _tasks = [
    const StudyTask(
      id: 'sample-1',
      title: 'Baca materi Pemrograman Perangkat Bergerak',
      description: 'Pelajari widget dasar dan struktur aplikasi Flutter.',
      category: 'Belajar',
      priority: TaskPriority.high,
    ),
    const StudyTask(
      id: 'sample-2',
      title: 'Latihan membuat halaman tugas',
      description: 'Buat form sederhana dan uji validasinya.',
      category: 'Tugas',
      priority: TaskPriority.medium,
    ),
    const StudyTask(
      id: 'sample-3',
      title: 'Kumpulkan ide proyek akhir',
      category: 'Proyek',
      priority: TaskPriority.low,
      completed: true,
    ),
  ];

  TaskFilter _filter = TaskFilter.all;
  String? _categoryFilter;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<StudyTask> get _visibleTasks {
    final query = _searchController.text.trim().toLowerCase();
    return _tasks.where((task) {
      final matchesStatus = switch (_filter) {
        TaskFilter.all => true,
        TaskFilter.active => !task.completed,
        TaskFilter.completed => task.completed,
      };
      final matchesCategory =
          _categoryFilter == null || task.category == _categoryFilter;
      final matchesSearch = query.isEmpty ||
          task.title.toLowerCase().contains(query) ||
          task.description.toLowerCase().contains(query);
      return matchesStatus && matchesCategory && matchesSearch;
    }).toList();
  }

  Future<void> _openForm({StudyTask? task}) async {
    final result = await Navigator.of(context).push<StudyTask>(
      MaterialPageRoute(
        builder: (_) => TaskFormScreen(initialTask: task),
      ),
    );
    if (!mounted || result == null) return;

    setState(() {
      final index = _tasks.indexWhere((item) => item.id == result.id);
      if (index == -1) {
        _tasks.insert(0, result);
      } else {
        _tasks[index] = result;
      }
    });
  }

  void _toggleTask(StudyTask task, bool completed) {
    setState(() {
      final index = _tasks.indexWhere((item) => item.id == task.id);
      if (index != -1) {
        _tasks[index] = _tasks[index].copyWith(completed: completed);
      }
    });
  }

  Future<void> _deleteTask(StudyTask task) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus tugas?'),
        content: Text('Tugas "${task.title}" akan dihapus.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _tasks.removeWhere((item) => item.id == task.id));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tugas berhasil dihapus.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final completedCount = _tasks.where((task) => task.completed).length;
    final visibleTasks = _visibleTasks;

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('StudyTracker'),
            Text('Rencanakan belajar, satu tugas setiap kali.'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('add-task'),
        onPressed: () => _openForm(),
        icon: const Icon(Icons.add),
        label: const Text('Tambah tugas'),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 88),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProgressSummary(
                    completed: completedCount,
                    total: _tasks.length,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    key: const Key('task-search'),
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Cari nama atau catatan tugas',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isEmpty
                          ? null
                          : IconButton(
                              tooltip: 'Hapus pencarian',
                              onPressed: () {
                                _searchController.clear();
                                setState(() {});
                              },
                              icon: const Icon(Icons.close),
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      for (final filter in TaskFilter.values)
                        ChoiceChip(
                          key: Key('filter-${filter.name}'),
                          label: Text(switch (filter) {
                            TaskFilter.all => 'Semua',
                            TaskFilter.active => 'Belum selesai',
                            TaskFilter.completed => 'Selesai',
                          }),
                          selected: _filter == filter,
                          onSelected: (_) => setState(() => _filter = filter),
                        ),
                      DropdownButton<String?>(
                        key: const Key('category-filter'),
                        value: _categoryFilter,
                        hint: const Text('Semua kategori'),
                        underline: const SizedBox.shrink(),
                        items: [
                          const DropdownMenuItem<String?>(
                            value: null,
                            child: Text('Semua kategori'),
                          ),
                          for (final category in taskCategories)
                            DropdownMenuItem<String?>(
                              value: category,
                              child: Text(category),
                            ),
                        ],
                        onChanged: (value) =>
                            setState(() => _categoryFilter = value),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Daftar tugas',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: visibleTasks.isEmpty
                        ? const _EmptyTasks()
                        : LayoutBuilder(
                            builder: (context, constraints) {
                              if (constraints.maxWidth >= 760) {
                                return GridView.builder(
                                  key: const Key('task-grid'),
                                  padding: const EdgeInsets.only(bottom: 12),
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 520,
                                    mainAxisExtent: 220,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 4,
                                  ),
                                  itemCount: visibleTasks.length,
                                  itemBuilder: (context, index) =>
                                      _taskCard(visibleTasks[index]),
                                );
                              }
                              return ListView.separated(
                                key: const Key('task-list'),
                                padding: const EdgeInsets.only(bottom: 12),
                                itemCount: visibleTasks.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 4),
                                itemBuilder: (context, index) =>
                                    _taskCard(visibleTasks[index]),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _taskCard(StudyTask task) {
    return TaskCard(
      task: task,
      onToggle: (completed) => _toggleTask(task, completed),
      onEdit: () => _openForm(task: task),
      onDelete: () => _deleteTask(task),
    );
  }
}

class _EmptyTasks extends StatelessWidget {
  const _EmptyTasks();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 48,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 10),
          Text(
            'Tidak ada tugas yang cocok.',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const Text('Coba ubah filter atau tambahkan tugas baru.'),
        ],
      ),
    );
  }
}
