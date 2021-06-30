import 'package:equatable/equatable.dart';
import 'package:todolist/models/subtasks.dart';

// ignore: must_be_immutable
class Task extends Equatable {
  /// Task Name/Title
  String title;

  /// Task ID
  int id;

  /// Task Key
  String taskKey;

  /// List of Subtasks associated with the Task
  List<Subtask> subtasks = [];

  /// GroupKey from the Group that added the task
  String groupKey;

  /// Name of Group that added the task
  String groupName;

  /// Has the Task been completed
  bool completed;

  /// Time Created
  DateTime timeCreated;

  /// Time Updated
  DateTime timeUpdated;

  /// Not Implemented
  String note;


  Task(
      {required this.title,
      required this.groupKey,
      required this.groupName,
      required this.completed,
      required this.id,
      required this.note,
      required this.taskKey,
      required this.timeCreated,
      required this.timeUpdated});

  factory Task.fromJson(Map<String, dynamic> parsedJson) {
    return Task(
        id: parsedJson['id'],
        title: parsedJson['title'],
        taskKey: parsedJson['task_key'],
        completed: parsedJson['completed'],
        note: parsedJson['note'],
        groupKey: parsedJson['group_key'],
        groupName: parsedJson['group_name'],
        timeCreated: DateTime.parse(parsedJson['time_created']),
        timeUpdated: DateTime.parse(parsedJson['time_updated']));
  }

  @override
  List<Object> get props => [taskKey];

  @override
  String toString() {
    return "Task Name: $title, Subtasks: ${subtasks.length}";
  }
}
