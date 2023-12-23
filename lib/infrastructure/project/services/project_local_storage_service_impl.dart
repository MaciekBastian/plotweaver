import 'dart:convert';
import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' as pp;

import '../../../core/constants/values.dart';
import '../../../domain/project/models/file_snippet_model.dart';
import '../../../domain/project/services/project_local_storage_service.dart';

@LazySingleton(as: ProjectLocalStorageService)
class ProjectLocalStorageServiceImpl implements ProjectLocalStorageService {
  Future<Directory> _getHistoryDirectory() async {
    final root = await pp.getApplicationSupportDirectory();
    final dir = Directory(p.join(root.path, PlotweaverNames.history));
    if (!dir.existsSync()) {
      await dir.create();
    }
    return dir;
  }

  Future<File> _getRecentFile() async {
    final dir = await _getHistoryDirectory();
    final file = File(
      p.join(
        dir.path,
        '${PlotweaverNames.recentFiles}.${PlotweaverNames.json}',
      ),
    );
    if (!file.existsSync()) {
      await file.create();
      await file.writeAsString('[]');
    }
    return file;
  }

  @override
  Future<void> addToRecentFiles(FileSnippetModel snippetModel) async {
    try {
      final file = await _getRecentFile();
      final models = await getRecentFiles();
      if (models.any((element) => element.path == snippetModel.path)) {
        return;
      } else {
        models.add(snippetModel);
        final content = models.map((e) => e.toJson()).toList();
        final encoded = json.encode(content);
        await file.writeAsString(encoded);
      }
    } catch (e) {
      return;
    }
  }

  @override
  Future<List<FileSnippetModel>> getRecentFiles() async {
    try {
      final file = await _getRecentFile();
      final content = await file.readAsString();
      final decoded = json.decode(content) as List<dynamic>;
      final models = decoded
          .map((e) => FileSnippetModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return models;
    } catch (e) {
      return [];
    }
  }
}
