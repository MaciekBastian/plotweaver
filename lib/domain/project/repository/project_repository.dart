import '../models/file_snippet_model.dart';

abstract class ProjectRepository {
  Future<FileSnippetModel?> pickFile();

  Future<List<FileSnippetModel>> getRecent();

  Future<void> addToRecent(FileSnippetModel file);
}
