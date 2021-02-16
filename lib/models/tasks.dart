class Task {
  String title; //project title
  int id; //project Id
  int index;
  String taskKey;
  List<Task> tasks; // tasks associated with the project
  String groupKey; // which group added that project
  String groupName;
  String note;
  bool completed; // has all tasks within the project been completed
  String repeats;
  List<DateTime> reminders;
  //DateTime deadline;

  Task({this.title, this.groupKey, this.groupName, this.completed, this.id, this.note,
      this.taskKey, this.index});

  factory Task.fromJson(Map<String, dynamic> parsedJson) {
    return Task(
      id:parsedJson['id'],
      title: parsedJson['title'],
      index: parsedJson['index'],
      taskKey :parsedJson['task_key'],
      completed: parsedJson['completed'],
      note: parsedJson['note'],
      groupKey: parsedJson['group_key'],
      groupName: parsedJson['group_name'],
    );
  }
}
