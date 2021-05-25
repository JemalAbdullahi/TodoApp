class Subtask {
  /// Subtask Name/Title
  String title;

  /// Subtask ID
  int subtaskId;

  /// Subtask Index in the list
  int index;

  /// Subtask Key
  String subtaskKey;

  /// Group Name
  String group;

  /// Has the subtask been completed
  bool completed;

  /// Not Implemented
  String note;

  /// Not Implemented
  String repeats;

  /// Not Implemented
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

  @override
  String toString() {
    return title;
  }
}
