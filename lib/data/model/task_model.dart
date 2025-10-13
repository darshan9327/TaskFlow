class TaskModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String priority;
  final String dueDate;
  final String status;
  final String userId;
  final String assignedTo;
  final String reviewerId;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.dueDate,
    required this.status,
    required this.userId,
    required this.assignedTo,
    required this.reviewerId,
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
    String? assignedTo,
    String? reviewerId,

  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ??   this.priority,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      userId: userId ?? this.userId,
      assignedTo: assignedTo ?? this.assignedTo,
      reviewerId: reviewerId ?? this.reviewerId,
    );
  }

  Map<String, dynamic> toMap({bool isNew = true}) => {
    'title': title,
    'description': description,
    'category': category,
    'priority': priority,
    'dueDate': dueDate,
    'status': status,
    'userId': userId,
    'assignedTo': assignedTo,
    'reviewerId': reviewerId,
    if (isNew) 'createdAt': DateTime.now(),
  };

  factory TaskModel.fromMap(String id, Map<String, dynamic> map) {
    return TaskModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      priority: map['priority'] ?? '',
      dueDate: map['dueDate'] ?? '',
      status: map['status'] ?? '',
      userId: map['userId'] ?? '',
      assignedTo: map['assignedTo'] ?? '',
      reviewerId: map['reviewerId'] ?? '',
    );
  }
}
