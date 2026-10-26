enum TaskPriority { low, medium, high }

extension TaskPriorityLabel on TaskPriority {
  String get label => switch (this) {
        TaskPriority.low => 'Rendah',
        TaskPriority.medium => 'Sedang',
        TaskPriority.high => 'Tinggi',
      };
}

class StudyTask {
  const StudyTask({
    required this.id,
    required this.title,
    this.description = '',
    this.category = 'Belajar',
    this.priority = TaskPriority.medium,
    this.dueDate,
    this.completed = false,
  });

  final String id;
  final String title;
  final String description;
  final String category;
  final TaskPriority priority;
  final DateTime? dueDate;
  final bool completed;

  StudyTask copyWith({
    String? title,
    String? description,
    String? category,
    TaskPriority? priority,
    bool? completed,
  }) {
    return StudyTask(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      dueDate: dueDate,
      completed: completed ?? this.completed,
    );
  }

  factory StudyTask.fromJson(Map<String, dynamic> json) {
    return StudyTask(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? 'Belajar',
      priority: TaskPriority.values.byName(
        json['priority'] as String? ?? TaskPriority.medium.name,
      ),
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
      completed: json['completed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'category': category,
        'priority': priority.name,
        'dueDate': dueDate?.toIso8601String(),
        'completed': completed,
      };
}
