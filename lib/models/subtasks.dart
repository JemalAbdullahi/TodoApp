import 'package:equatable/equatable.dart';

import 'groupmember.dart';

// ignore: must_be_immutable
class Subtask extends Equatable {
  /// Subtask Name/Title
  String title;

  /// Subtask ID
  int subtaskId;

  /// Subtask Key
  String subtaskKey;

  /// Has the subtask been completed
  bool completed;

  /// Time Created
  DateTime timeCreated;

  /// Time Updated
  DateTime timeUpdated;

  /// Deadline
  late DateTime? deadline;

  /// Not Implemented
  String note;

  List<GroupMember> assignedTo = [];

  late List<GroupMember> allGroupMembers;

  Subtask(this.title, this.completed, this.subtaskId, this.note,
      this.subtaskKey, this.timeCreated, this.timeUpdated);

  factory Subtask.fromJson(Map<String, dynamic> parsedJson) {
    return Subtask(
      parsedJson['title'],
      parsedJson['completed'],
      parsedJson['id'],
      parsedJson['note'],
      parsedJson['subtask_key'],
      DateTime.parse(parsedJson['time_created']),
      DateTime.parse(parsedJson['time_updated']),
    );
  }

  @override
  List<Object> get props => [subtaskKey];

  @override
  String toString() {
    return title;
  }
}
