class TodoItem {
  int id = 0;
  String title = '';
  String description = '';
  DateTime deadline = DateTime.now();
  bool done = false;
  String? fbid; // firebase id
  String? ownerId; // fireebase user id

  TodoItem(
      {this.id = 0,
      required this.title,
      required this.description,
      required this.deadline,
      required this.done});

  Map<String, dynamic> toMap() {
    // tarkista
    return {
      'title': title,
      'description': description,
      'deadline': deadline.millisecondsSinceEpoch,
      'done': done ? 1 : 0
    };
  }

  TodoItem.fromJson(Map<dynamic, dynamic> json)
      : title = json['title'],
        description = json['description'],
        deadline = DateTime.parse(json['deadline'] as String),
        done = json['done'] as bool;

  Map<String, dynamic> toJson() => <String, dynamic>{
        "title": title,
        "description": description,
        "deadline": deadline.toString(),
        "done": done
      };
}
