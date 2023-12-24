import '../../global/models/file_snippet_model.dart';

abstract class ProjectLocalStorageService {
  Future<List<FileSnippetModel>> getRecentFiles();

  Future<void> addToRecentFiles(FileSnippetModel snippetModel);
}
