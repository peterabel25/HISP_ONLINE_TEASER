class Todo {
  late String id;
  String? title;
  String? description;
  bool? completed;
  String? created;
  String? lastUpdated;

  Todo({
    required this.id,
    required this.title,
    required this.created,
    required this.lastUpdated,
    required this.description,
    required this.completed,
  });

  
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['value']['id'],
      title: json['value']['title'],
      description: json['value']['description'],
      completed: json['value']['completed'],
      created: json['value']['created'],
      lastUpdated: json['value']['lastUpdated'],
    );
  }


Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'completed': completed,
      'created': created,
      'lastUpdated': lastUpdated,
    };
  }


}
