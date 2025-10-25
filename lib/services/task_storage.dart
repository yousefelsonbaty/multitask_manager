import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../models/task.dart';

class TaskStorage {
  static const _fileName = 'tasks.json';

  Future<File> _localFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_fileName');
  }

  Future<List<Task>> loadTasks() async {
    try {
      final file = await _localFile();
      if (!await file.exists()) {
        await file.writeAsString('[]');
        return [];
      }
      final contents = await file.readAsString();
      final List<dynamic> jsonList = jsonDecode(contents) as List<dynamic>;
      return jsonList.map((e) => Task.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      // If anything goes wrong, return an empty list.
      return [];
    }
  }

  Future<void> saveTasks(List<Task> tasks) async {
    final file = await _localFile();
    final jsonList = tasks.map((t) => t.toJson()).toList();
    await file.writeAsString(jsonEncode(jsonList));
  }
}
