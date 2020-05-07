
class Task {
  String group;
  List<Task> tasks;
  String note;
  DateTime timeToComplete;
  bool completed;
  String repeats;
  DateTime deadline;
  List<DateTime> reminders;
  int taskId;
  String title;
  
  Task(this.title, this.completed, this.taskId);

}