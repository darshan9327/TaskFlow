class TaskModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String priority;
  final String dueDate;
  final String status;
  final String userId;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.dueDate,
    required this.status,
    required this.userId,
  });

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? priority,
    String? dueDate,
    String? status,
    String? userId,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'priority': priority,
      'dueDate': dueDate,
      'status': status,
      'userId': userId,
    };
  }

  factory TaskModel.fromMap(String id, Map<String, dynamic> map) {
    return TaskModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      priority: map['priority'] ?? '',
      dueDate: map['dueDate'] ?? '',
      status: map['status'] ?? 'pending',
      userId: map['userId'] ?? '',
    );
  }
}
