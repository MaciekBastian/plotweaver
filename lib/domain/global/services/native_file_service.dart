import '../../project/models/file_snippet_model.dart';

abstract class NativeFileService {
  Future<FileSnippetModel?> pickFile();
}
