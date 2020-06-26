class Task {
  String title; //project title
  int taskId; //project Id
  int index;
  String taskKey;
  List<Task> tasks; // tasks associated with the project
  String group; // which group added that project
  String note;
  DateTime timeToComplete;
  bool completed; // has all tasks within the project been completed
  String repeats;
  List<DateTime> reminders;
  //DateTime deadline;

  Task(this.title, this.group, this.completed, this.taskId, this.note,
      this.taskKey, this.index);

  factory Task.fromJson(Map<String, dynamic> parsedJson) {
    return Task(
      parsedJson['title'],
      parsedJson['group'],
      parsedJson['completed'],
      parsedJson['id'],
      parsedJson['note'],
      parsedJson['task_key'],
      parsedJson['index'],
    );
  }
}
