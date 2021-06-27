import 'package:equatable/equatable.dart';

import 'groupmember.dart';

// ignore: must_be_immutable
class Subtask extends Equatable{
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

  /// Time Created
  DateTime timeCreated;

  /// Time Updated
  DateTime timeUpdated;

  /// Deadline
  late DateTime deadline;

  /// Not Implemented
  String note;
  
  //DateTime deadline;
  late List<GroupMember> assignedTo;

  Subtask(this.title, this.group, this.completed, this.subtaskId, this.note,
      this.subtaskKey, this.index, this.timeCreated, this.timeUpdated);

  factory Subtask.fromJson(Map<String, dynamic> parsedJson) {
    return Subtask(
        parsedJson['title'],
        parsedJson['group'],
        parsedJson['completed'],
        parsedJson['id'],
        parsedJson['note'],
        parsedJson['subtask_key'],
        parsedJson['index'],
        DateTime.parse(parsedJson['time_created']),
        DateTime.parse(parsedJson['time_updated']));
  }

  @override
  List<Object> get props => [subtaskKey];

  @override
  String toString() {
    return title;
  }
}
