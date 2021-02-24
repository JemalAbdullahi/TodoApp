class Subtask {
  String title; //project title
  int subtaskId; //project Id
  int index;
  String subtaskKey;
  String group;
  String note;
  bool completed; // has all tasks within the project been completed
  String repeats;
  List<DateTime> reminders;
  //DateTime deadline;

  Subtask(this.title, this.group, this.completed, this.subtaskId, this.note,
      this.subtaskKey, this.index);

  factory Subtask.fromJson(Map<String, dynamic> parsedJson) {
    return Subtask(
      parsedJson['title'],
      parsedJson['group'],
      parsedJson['completed'],
      parsedJson['id'],
      parsedJson['note'],
      parsedJson['subtask_key'],
      parsedJson['index'],
    );
  }
}
