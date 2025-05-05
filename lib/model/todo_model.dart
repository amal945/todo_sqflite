class Todo {
  final int? id;
  final int userId;
  final String title;
  final String description;
  final bool isCompleted;
  final String? completedAt;
  final String createdAt;
  final String? updatedAt;

  Todo({
    this.id,
    required this.userId,
    required this.title,
    required this.description,
    this.isCompleted = false,
    this.completedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
      'completedAt': completedAt,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      userId: map['userId'],
      title: map['title'],
      description: map['description'],
      isCompleted: map['isCompleted'] == 1,
      completedAt: map['completedAt'], 
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }
}
