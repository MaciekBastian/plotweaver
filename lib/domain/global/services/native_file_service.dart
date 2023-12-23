import '../models/file_snippet_model.dart';

abstract class NativeFileService {
  Future<FileSnippetModel?> pickFile();

  Future<Uri?> pickDirectory();

  Future<FileSnippetModel?> createNewProjectFile();
}
