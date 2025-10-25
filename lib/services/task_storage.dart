import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show kDebugMode;
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
      // In debug mode prefer the bundled sample asset so edits to data/tasks.json
      // in the workspace are reflected more quickly during development (hot-restart).
      if (kDebugMode) {
        try {
          final asset = await rootBundle.loadString('data/tasks.json');
          // If local file doesn't exist or differs from asset, overwrite it with the asset
          if (!await file.exists()) {
            await file.writeAsString(asset);
          } else {
            final local = await file.readAsString();
            if (local.trim() != asset.trim()) {
              await file.writeAsString(asset);
            }
          }
          final List<dynamic> jsonList = jsonDecode(asset) as List<dynamic>;
          return jsonList.map((e) => Task.fromJson(e as Map<String, dynamic>)).toList();
        } catch (_) {
          // Fall back to reading the local file if asset isn't available for some reason
        }
      }

      // Production or fallback: read from the local file. If it's missing or empty, return an empty list.
      if (!await file.exists()) {
        await file.writeAsString('[]');
        return [];
      }

      var contents = await file.readAsString();
      if (contents.trim().isEmpty || contents.trim() == '[]') return [];
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
