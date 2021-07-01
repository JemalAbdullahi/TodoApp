import 'package:todolist/bloc/blocs/user_bloc_provider.dart';
import 'package:todolist/bloc/resources/repository.dart';
import 'package:todolist/models/groupmember.dart';
import 'package:todolist/models/subtasks.dart';

class SubtaskViewModel {
  final Subtask subtask;
  final SubtaskBloc subtaskBloc;
  final List<GroupMember> members;

  SubtaskViewModel({required this.subtask, required this.subtaskBloc, required this.members}){
    getUsersAssignedtoSubtask();
  }

  String get title {
    return this.subtask.title;
  }

  String get note {
    return this.subtask.note;
  }

  set note(String note) {
    subtask.note = note;
  }

  void selected(GroupMember groupMember, bool selected) {
    groupMember.selectedForAssignment = selected;
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

  Future<void> getUsersAssignedtoSubtask() async {
    subtask.assignedTo = await repository.getUsersAssignedToSubtask(subtask.subtaskKey);
    for (GroupMember user in members) {
      if(subtask.assignedTo.contains(user)){
        selected(user, true);
      }
    }
  }

  Future<void> assignSubtaskToUser(int index) async{
    repository.assignSubtaskToUser(subtask.subtaskKey, members[index].username);
    subtask.assignedTo.add(members[index]);
    selected(members[index], true);
  }

  Future<void> unassignSubtaskToUser(int index) async{
    repository.unassignSubtaskToUser(subtask.subtaskKey, members[index].username);
    subtask.assignedTo.remove(members[index]);
    selected(members[index], false);
  }

  void updateSubtaskInfo() {
    subtaskBloc.updateSubtaskInfo(this.subtask);
  }
}
