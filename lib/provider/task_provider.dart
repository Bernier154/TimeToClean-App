import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:ttc_app/models/task.dart';

class TaskProvider {
  List<Task> taskList = [];
  List<Task> get sortedTaskList {
    List<Task> l = List<Task>.from(taskList);
    l.sort((a, b) => a.timeLeftMilliseconds.compareTo(b.timeLeftMilliseconds));
    return l;
  }

  void createOrUpdate(Task task) {
    log(task.id);
    inspect(taskList);
    final index = taskList.indexWhere((t) => t.id == task.id);
    log(index.toString());
    if (index != -1) {
      taskList[index] = task;
    } else {
      taskList.add(task);
    }

    save();
  }

  Task? getTask(String taskId) {
    try {
      Task task = taskList.firstWhere((t) => t.id == taskId);
      return task;
    } catch (exception) {
      log('Task with id $taskId could no be found');
    }
    return null;
  }

  void deleteTask(String taskId) {
    Task? task = getTask(taskId);
    if (task != null) {
      taskList = taskList.where((t) => t.id != taskId).toList();
    }
  }

  fetch() async {
    final prefs = await SharedPreferences.getInstance();
    taskList = (prefs.getStringList('tasks') ?? []).map((s) => Task.fromString(s)).toList();
  }

  save() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('tasks', taskList.map((t) => t.toString()).toList());
  }
}
