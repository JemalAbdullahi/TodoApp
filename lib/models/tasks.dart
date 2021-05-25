import 'package:todolist/models/subtasks.dart';

class Task {
  /// Task Name/Title
  String title;

  /// Task ID
  int id;

  /// Task Index in the list
  int index;

  /// Task Key
  String taskKey;

  /// List of Subtasks associated with the Task
  List<Subtask> subtasks;

  /// GroupKey from the Group that added the task
  String groupKey;

  /// Name of Group that added the task
  String groupName;

  /// Has the Task been completed
  bool completed;

  /// Not Implemented
  String repeats;

  /// Not Implemented
  String note;

  /// Not Implemented
  List<DateTime> reminders;
  //DateTime deadline;

  Task(
      {this.title,
      this.groupKey,
      this.groupName,
      this.completed,
      this.id,
      this.note,
      this.taskKey,
      this.index});

  factory Task.fromJson(Map<String, dynamic> parsedJson) {
    return Task(
      id: parsedJson['id'],
      title: parsedJson['title'],
      index: parsedJson['index'],
      taskKey: parsedJson['task_key'],
      completed: parsedJson['completed'],
      note: parsedJson['note'],
      groupKey: parsedJson['group_key'],
      groupName: parsedJson['group_name'],
    );
  }

  @override
  String toString() {
    return "Task Name: $title, Subtasks: ${subtasks.length}";
  }
}
