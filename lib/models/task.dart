import 'dart:convert';

class Task {
  String id;
  String title;
  bool completed;
  DateTime? dueDate;

  Task({required this.id, required this.title, this.completed = false, this.dueDate});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      completed: json['completed'] as bool? ?? false,
      dueDate: json['dueDate'] == null ? null : DateTime.parse(json['dueDate'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'completed': completed,
      'dueDate': dueDate?.toIso8601String(),
    };
  }

  @override
  String toString() => jsonEncode(toJson());

  /// Return a copy of this task with fields replaced by the non-null
  /// parameters. Useful for immutable-style updates.
  Task copyWith({String? id, String? title, bool? completed, DateTime? dueDate}) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
      dueDate: dueDate ?? this.dueDate,
    );
  }
}
