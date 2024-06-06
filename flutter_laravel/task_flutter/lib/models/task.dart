class Task {
  int id;
  String title;
  String description;
  bool isCompleted;

  Task({required this.id, required this.title, required this.description, required this.isCompleted});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      isCompleted: json['is_completed'] == 1, // intをboolに変換
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'is_completed': isCompleted ? 1 : 0, // boolをintに変換
    };
  }
}