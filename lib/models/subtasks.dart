
class SubTask {
  String title; //project title
  String note;    
  bool completed;   // has all tasks within the project been completed
  String repeats;
  String group;
  //DateTime deadline;
  List<DateTime> reminders;
  int subtaskId;   //project Id
  
  SubTask(this.title, this.group, this.completed, this.subtaskId, this.note);

    factory SubTask.fromJson(Map<String, dynamic> parsedJson) {
    return SubTask(
      parsedJson['title'],
      parsedJson['group'],
      parsedJson['completed'],
      parsedJson['id'],
      parsedJson['note'],
      );
  }

}