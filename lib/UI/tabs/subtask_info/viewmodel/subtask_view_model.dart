import 'package:todolist/bloc/blocs/user_bloc_provider.dart';
import 'package:todolist/models/groupmember.dart';
import 'package:todolist/models/subtasks.dart';

class SubtaskViewModel {
  final Subtask subtask;
  final SubtaskBloc subtaskBloc;

  SubtaskViewModel({required this.subtask, required this.subtaskBloc});

  String get title {
    return this.subtask.title;
  }

  String get note {
    return this.subtask.note;
  }

  set note(String note) {
    subtask.note = note;
  }

  DateTime get deadline {
    return this.subtask.deadline ?? DateTime.now();
  }

  set deadline(DateTime deadline) {
    subtask.deadline = deadline;
  }

  List<GroupMember> get assignedTo {
    return this.subtask.assignedTo;
  }

  List<GroupMember> get allGroupMembers {
    return this.subtask.allGroupMembers;
  }

  void updateSubtaskInfo() {
    subtaskBloc.updateSubtaskInfo(this.subtask);
  }
}
