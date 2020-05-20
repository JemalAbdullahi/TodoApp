
class Task {
  String group; // which group added that project
  List<Task> tasks; // tasks associated with the project
  String note;    
  DateTime timeToComplete;
  bool completed;   // has all tasks within the project been completed
  String repeats;
  //DateTime deadline;
  List<DateTime> reminders;
  int taskId;   //project Id
  String title; //project title
  
  Task(this.title, this.group, this.completed, this.taskId, this.note);

    factory Task.fromJson(Map<String, dynamic> parsedJson) {
    return Task(
      parsedJson['title'],
      parsedJson['group'],
      parsedJson['completed'],
      parsedJson['id'],
      parsedJson['note'],
      );
  }

}