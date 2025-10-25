import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
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
        // If no local file exists yet, try to load sample data from bundled assets
        try {
          final asset = await rootBundle.loadString('data/tasks.json');
          await file.writeAsString(asset);
          final List<dynamic> jsonList = jsonDecode(asset) as List<dynamic>;
          return jsonList.map((e) => Task.fromJson(e as Map<String, dynamic>)).toList();
        } catch (_) {
          await file.writeAsString('[]');
          return [];
        }
      }

      var contents = await file.readAsString();
      if (contents.trim().isEmpty || contents.trim() == '[]') {
        // If local file exists but is empty or contains an empty list, try to populate from bundled sample
        try {
          final asset = await rootBundle.loadString('data/tasks.json');
          await file.writeAsString(asset);
          final List<dynamic> jsonList = jsonDecode(asset) as List<dynamic>;
          return jsonList.map((e) => Task.fromJson(e as Map<String, dynamic>)).toList();
        } catch (_) {
          return [];
        }
      }

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
